Git <- R6Class(
  "Git",
  public = list(
    initialize = function(path) {
      private$path <- path
    },

    cmd = function(...) {
      args <- c(...)
      message(paste("git", paste(args, collapse = " ")))
      status <- withr::with_dir(private$path, system2("git", args))
      if (status != 0) {
        stopc("git exited with status ", status)
      }
    },

    query = function(...) {
      args <- c(...)
      message(paste("git", paste(args, collapse = " ")))
      withr::with_dir(private$path, system2("git", args, stdout = TRUE))
    },

    init_repo = function() {
      message("Initializing Git repo at ", private$path)
      dir.create(private$path, recursive = TRUE, showWarnings = FALSE)
      private$repo <- git2r::init(private$path)
    },

    get_repo = function() {
      private$repo
    }
  ),

  private = list(
    path = NULL,
    repo = NULL
  )
)

SetupPushDeploy <- R6Class(
  "SetupPushDeploy",
  inherit = TicStep,

  public = list(
    initialize = function(path = ".", branch = NULL, orphan = FALSE,
                          remote_url = NULL, checkout = TRUE) {

      if (is.null(branch) && orphan) {
        stop("Cannot orphan the branch that has been used for the CI run.", call. = FALSE)
      }

      if (is.null(branch) && path != ".") {
        stop("Must specify branch name if `path` is given.", call. = FALSE)
      }

      if (path != "." && !checkout && !orphan) {
        stop("If `checkout` is FALSE and `path` is set, `orphan` must be TRUE.")
      }

      if (is.null(branch)) {
        branch <- ci_get_branch()
      }

      if (is.null(remote_url)) {
        remote_url <- paste0("git@github.com:", ci_get_slug(), ".git")
      }

      private$git <- Git$new(path)
      private$branch <- branch
      private$orphan <- orphan
      private$remote_url <- remote_url
      private$checkout <- checkout
    },

    prepare = function() {
      verify_install("git2r")
      super$prepare()
    },

    run = function() {
      private$git$init_repo()
      private$init_author()
      private$fetch()
    }
  ),

  private = list(
    git = NULL,

    branch = NULL,
    orphan = FALSE,
    remote_url = NULL,
    checkout = FALSE,

    repo = NULL,
    remote_name = "tic-remote", # HACK

    init_author = function() {
      latest_commit <- get_head_commit(git2r_head(git2r::repository(".")))
      print(latest_commit)

      latest_author <- git2r_attrib(latest_commit, "author")
      print(latest_author)

      git2r::config(
        private$git$get_repo(),
        user.name = git2r_attrib(latest_author, "name"),
        user.email = git2r_attrib(latest_author, "email")
      )
    },

    fetch = function() {
      remote_name <- private$remote_name

      if (remote_name %in% git2r::remotes(private$git$get_repo())) {
        message("Not overriding existing remote ", remote_name)
      } else {
        message("Adding remote ", remote_name, " with URL ", private$remote_url)
        git2r::remote_add(private$git$get_repo(), remote_name, private$remote_url)
      }

      message("Setting branch name to ", private$branch)
      private$git$cmd("checkout", "-B", private$branch)

      if (!private$orphan) {
        message("Fetching from remote ", remote_name)
        tryCatch(
          {
            remote_branch <- private$try_fetch()
            if (!is.null(remote_branch)) {
              message("Remote branch is ", remote_branch)
              if (private$checkout) {
                git2r::checkout(
                  private$git$get_repo(),
                  private$branch,
                  create = TRUE,
                  force = TRUE
                )
              }
            }
          },
          error = function(e) {
            message(
              conditionMessage(e),
              "\nCould not fetch branch, will attempt to create new"
            )
          }
        )
      }
    },

    try_fetch = function() {
      remote_name <- private$remote_name
      private$git$cmd("fetch", remote_name, paste0("refs/heads/", private$branch))
      branches <- git2r::branches(private$git$get_repo(), "remote")
      branches[[paste0(remote_name, "/", private$branch)]]
    }
  )
)

#' Step: Setup push deploy
#'
#' Clones a repo, inits author information, and sets up remotes
#' for a subsequent [step_do_push_deploy()].
#'
#' @param path `[string]`\cr
#'   Path to the repository, default `"."` which means setting up the current
#'   repository.
#' @param branch `[string]`\cr
#'   Target branch, default: current branch.
#' @param orphan `[flag]`\cr
#'   Create and force-push an orphan branch consisting of only one commit?
#'   This can be useful e.g. for `path = "docs", branch = "gh-pages"`,
#'   but cannot be applied for pushing to the current branch.
#' @param remote_url `[string]`\cr
#'   The URL of the remote Git repository to push to, defaults to the
#'   current GitHub repository.
#' @param checkout `[flag]`\cr
#'   Check out the current contents of the repository? Defaults to `TRUE`,
#'   set to `FALSE` if the build process relies on existing contents or
#'   if you deploy to a different branch.
#'
#' @family deploy steps
#' @family steps
#' @export
step_setup_push_deploy <- function(path = ".", branch = NULL, orphan = FALSE,
                                   remote_url = NULL, checkout = TRUE) {
  SetupPushDeploy$new(
    path = path, branch = branch, orphan = orphan,
    remote_url = remote_url, checkout = checkout
  )
}

DoPushDeploy <- R6Class(
  "DoPushDeploy",
  inherit = TicStep,

  public = list(
    initialize = function(path = ".", commit_message = NULL, commit_paths = ".") {
      private$git <- Git$new(path)

      if (is.null(commit_message)) {
        commit_message <- private$format_commit_message()
      }
      private$commit_message <- commit_message
      private$commit_paths <- commit_paths
    },

    check = function() {
      !ci_is_tag()
    },

    prepare = function() {
      verify_install("git2r")
      super$prepare()
    },

    run = function() {
      private$git$init_repo()
      maybe_orphan <- is.null(git2r_head(private$git$get_repo()))
      if (private$commit()) {
        private$push(force = maybe_orphan)
      }
    }
  ),

  private = list(
    git = NULL,

    commit_message = NULL,
    commit_paths = NULL,

    repo = NULL,
    remote_name = "tic-remote", # HACK

    commit = function() {
      message("Staging: ", paste(private$commit_paths, collapse = ", "))
      git2r::add(private$git$get_repo(), private$commit_paths)

      message("Checking changed files")
      status <- git2r::status(private$git$get_repo(), staged = TRUE, unstaged = FALSE, untracked = FALSE, ignored = FALSE)
      if (length(status$staged) == 0) {
        message("Nothing to commit!")
        return(FALSE)
      }

      message("Committing to ", git2r_attrib(private$git$get_repo(), "path"))
      new_commit <- git2r::commit(private$git$get_repo(), private$commit_message)$sha

      local <- git2r_head(private$git$get_repo())
      upstream <- git2r::branch_get_upstream(local)
      if (is.null(upstream)) {
        message("No upstream branch found")
        return(TRUE)
      }

      message("Wiping repository")
      private$git$cmd("checkout .")
      private$git$cmd("clean -fdx")

      message("Pulling new changes")
      private$git$cmd("pull --rebase -X theirs")

      c_local <- git2r::lookup(private$git$get_repo(), git2r::branch_target(local))
      c_upstream <- git2r::lookup(private$git$get_repo(), git2r::branch_target(upstream))

      ab <- git2r::ahead_behind(c_local, c_upstream)
      message("Ahead: ", ab[[1]], ", behind: ", ab[[2]])
      ab[[1]] > 0
    },

    push = function(force) {
      message("Pushing to remote")
      private$git$cmd(
        "push",
        if (force) "--force",
        private$remote_name,
        "HEAD"
      )
    },

    format_commit_message = function() {
      paste0(
        "Deploy from ", ci_get_build_number(), " [ci skip]\n\n",
        if (!is.null(ci_get_build_url())) paste0("Build URL: ", ci_get_build_url(), "\n"),
        "Commit: ", ci_get_commit()
      )
    }
  )
)

#' Step: Perform push deploy
#'
#' Commits and pushes to a repo prepared by [step_setup_push_deploy()].
#' It is highly recommended to restrict the set of files
#' touched by the deployment with the `commit_paths` argument:
#' this step assumes that it can freely overwrite all changes to all files
#' below `commit_paths`, and will not warn in case of conflicts.
#'
#' To mitigate conflicts race conditions to the greatest extent possible,
#' the following strategy is used:
#'
#' - The changes are committed to the branch
#' - Before pushing, new commits are fetched with `git pull --rebase -X theirs`
#'
#' If no new commits were pushed after the CI run has started,
#' this strategy is equivalent to simply committing and pushing.
#' In the opposite case, if the remote repo has new commits,
#' the deployment is safely applied to the current tip.
#'
#' @inheritParams step_setup_push_deploy
#' @param commit_message `[string]`\cr
#'   Commit message to use, defaults to a useful message linking to the CI build
#'   and avoiding recursive CI runs.
#' @param commit_paths `[character]`\cr
#'   Restrict the set of directories and/or files added to Git before deploying.
#'   Default: deploy all files.
#'
#' @family deploy steps
#' @family steps
#'
#' @export
step_do_push_deploy <- function(path = ".", commit_message = NULL, commit_paths = ".") {
  DoPushDeploy$new(path = path, commit_message = commit_message, commit_paths = commit_paths)
}

PushDeploy <- R6Class(
  "PushDeploy",
  inherit = TicStep,

  public = list(
    initialize = function(path = ".", branch = ci_get_branch(),
                          remote_url = paste0("git@github.com:", ci_get_slug(), ".git"),
                          commit_message = NULL, commit_paths = ".") {

      orphan <- (path != ".")

      private$setup <- step_setup_push_deploy(
        path = path, branch = branch, orphan = orphan, remote_url = remote_url,
        checkout = FALSE
      )

      private$do <- step_do_push_deploy(
        path = path, commit_message = commit_message, commit_paths = commit_paths
      )
    },

    check = function() {
      private$setup$check() && private$do$check()
    },

    prepare = function() {
      private$setup$prepare()
      private$do$prepare()
    },

    run = function() {
      private$setup$run()
      private$do$run()
    }
  ),

  private = list(
    setup = NULL,
    do = NULL
  )
)

#' Step: Setup and perform push deploy
#'
#' Clones a repo, inits author information, sets up remotes,
#' commits, and pushes.
#' Combines [step_setup_push_deploy()] with `checkout = FALSE` and
#' a suitable `orphan` argument,
#' and [step_do_push_deploy()].
#'
#' Setup and deployment are combined in one step,
#' the files to be deployed must be prepared in a previous step.
#' This poses some restrictions on how the repository can be initialized,
#' in particular for a nonstandard `path` argument only `orphan = TRUE`
#' can be supported (and will be used).
#'
#' For more control, create two separate steps with
#' `step_setup_push_deploy()` and `step_do_push_deploy()`,
#' and create the files to be deployed inbetween these steps.
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#'
#' @family deploy steps
#' @family steps
#'
#' @export
step_push_deploy <- function(path = ".", branch = NULL,
                             remote_url = NULL,
                             commit_message = NULL, commit_paths = ".") {
  PushDeploy$new(
    path = path, branch = branch,
    remote_url = remote_url,
    commit_message = commit_message,
    commit_paths = commit_paths
  )
}
