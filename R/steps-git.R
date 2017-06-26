AddToKnownHosts <- R6Class(
  "AddToKnownHosts", inherit = TicStep,

  public = list(
    initialize = function(host) {
      private$host <- host
    },

    run = function() {
      message("Running ssh-keyscan for ", private$host)
      keyscan_result <- system2(
        "ssh-keyscan",
        c("-H", shQuote(private$host)),
        stdout = TRUE
      )
      cat(keyscan_result, "\n", sep = "")

      known_hosts_path <- file.path("~", ".ssh", "known_hosts")
      dir.create(dirname(known_hosts_path), showWarnings = FALSE, recursive = TRUE)
      message("Adding to ", known_hosts_path)
      write(keyscan_result, known_hosts_path, append = TRUE)
    },

    check = function() {
      # only if non-interactive and ssh-keyscan is available
      (!ci()$is_interactive()) && (Sys.which("ssh-keyscan") != "")
    }
  ),

  private = list(
    host = NULL
  )
)

#' @export
step_add_to_known_hosts <- AddToKnownHosts$new

InstallSSHKeys <- R6Class(
  "InstallSSHKeys", inherit = TicStep,

  public = list(
    run = function() {
      deploy_key_path <- file.path("~", ".ssh", "id_rsa")
      message("Writing deploy key to ", deploy_key_path)
      if (file.exists(deploy_key_path)) {
        stop("Not overwriting key", call. = FALSE)
      }
      writeLines(rawToChar(openssl::base64_decode(Sys.getenv("id_rsa"))),
                 deploy_key_path)
      Sys.chmod(deploy_key_path, "600")
    },

    prepare = function() {
      verify_install("openssl")
    },

    check = function() {
      # only if non-interactive and id_rsa env var is available
      (!ci()$is_interactive()) && (Sys.getenv("id_rsa") != "")
    }
  )
)

#' @export
step_install_ssh_keys <- InstallSSHKeys$new

TestSSH <- R6Class(
  "TestSSH", inherit = TicStep,

  public = list(
    initialize = function(host = "git@github.com", verbose = "-v") {
      private$host <- host
      private$verbose <- verbose
    },

    run = function() {
      message("Trying to ssh into git@github.com")
      system2("ssh", c(private$host, private$verbose))
    }
  ),

  private = list(
    host = NULL,
    verbose = NULL
  )
)

#' @export
step_test_ssh <- TestSSH$new

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
  "SetupPushDeploy", inherit = TicStep,

  public = list(
    initialize = function(path = ".", branch = ci()$get_branch(), orphan = FALSE,
                          remote_url = paste0("git@github.com:", ci()$get_slug(), ".git"),
                          checkout = TRUE) {

      if (branch == ci()$get_branch() && orphan) {
        stop("Cannot orphan the branch that has been used for the CI run.", call. = FALSE)
      }

      private$git <- Git$new(path)
      private$branch <- branch
      private$orphan <- orphan
      private$remote_url <- remote_url
      private$checkout <- checkout
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
    remote_name = "origin", # HACK

    init_author = function() {
      latest_commit <- get_head_commit(git2r::head(git2r::repository(".")))
      print(latest_commit)

      latest_author <- latest_commit@author
      print(latest_author)

      git2r::config(private$git$get_repo(), user.name = latest_author@name, user.email = latest_author@email)
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
              if (private$checkout) {
                git2r::checkout(
                  private$git$get_repo(),
                  private$branch,
                  create = TRUE,
                  force = TRUE
                )
              } else {
                git2r::reset(get_head_commit(remote_branch))
              }
            }
          },
          error = function(e) {
            message(conditionMessage(e),
                    "\nCould not fetch branch, will attempt to create new")
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

#' @export
step_setup_push_deploy <- SetupPushDeploy$new

DoPushDeploy <- R6Class(
  "PushDeploy", inherit = TicStep,

  public = list(
    initialize = function(path = ".", commit_message = NULL) {
      private$git <- Git$new(path)

      if (is.null(commit_message)) {
        commit_message <- private$format_commit_message()
      }
      private$commit_message <- commit_message
    },

    run = function() {
      private$git$init_repo()
      maybe_orphan <- is.null(git2r::head(private$git$get_repo()))
      if (private$commit()) private$push(force = maybe_orphan)
    }
  ),

  private = list(
    git = NULL,

    commit_message = NULL,

    repo = NULL,
    remote_name = "origin", # HACK

    commit = function() {
      message("Committing to ", private$git$get_repo()@path)
      git2r::add(private$git$get_repo(), ".")
      status <- git2r::status(private$git$get_repo(), staged = TRUE, unstaged = FALSE, untracked = FALSE, ignored = FALSE)
      if (length(status$staged) > 0) {
        git2r::commit(private$git$get_repo(), private$commit_message)
        TRUE
      } else {
        message("Nothing to commit!")
        FALSE
      }
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
        "Deploy from ", ci()$get_build_number(), " [ci skip]\n\n",
        if (!is.null(ci()$get_build_url())) paste0("Build URL: ", ci()$get_build_url(), "\n"),
        "Commit: ", ci()$get_commit()
      )
    }
  )
)

#' @export
step_do_push_deploy <- DoPushDeploy$new

PushDeploy <- R6Class(
  "PushDeploy", inherit = TicStep,

  public = list(
    initialize = function(path = ".", branch = ci()$get_branch(), orphan = FALSE,
                          remote_url = paste0("git@github.com:", ci()$get_slug(), ".git"),
                          commit_message = NULL) {

      private$setup <- step_setup_push_deploy(
        path = path, branch = branch, orphan = orphan, remote_url = remote_url
      )

      private$do <- step_do_push_deploy(
        path = path, commit_message = commit_message
      )

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

#' @export
step_push_deploy <- PushDeploy$new
