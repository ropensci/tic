InstallSSHKeys <- R6Class(
  "InstallSSHKeys", inherit = TravisTask,

  public = list(
    run = function() {
      deploy_key_path <- file.path("~/.ssh", "id_rsa")
      message("Writing deploy key to ", deploy_key_path)
      if (file.exists(deploy_key_path)) {
        stop("Not overwriting key", call. = FALSE)
      }
      writeLines(rawToChar(openssl::base64_decode(Sys.getenv("id_rsa"))),
                 deploy_key_path)
      Sys.chmod(deploy_key_path, "600")
    },

    prepare = function() {
      if (!requireNamespace("openssl", quietly = TRUE))
        install.packages("openssl")
    },

    check = function() {
      # only if id_rsa is available
      Sys.getenv("id_rsa") != ""
    }
  )
)

#' @export
task_install_ssh_keys <- InstallSSHKeys$new

TestSSH <- R6Class(
  "TestSSH", inherit = TravisTask,

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
task_test_ssh <- TestSSH$new

PushDeploy <- R6Class(
  "PushDeploy", inherit = TravisTask,

  public = list(
    initialize = function(path = ".", branch = NULL, orphan = FALSE,
                          remote_url = paste0("git@github.com:", Sys.getenv("TRAVIS_REPO_SLUG"), ".git"),
                          commit_message = NULL) {
      private$path <- path
      private$branch <- branch
      private$orphan <- orphan
      private$remote_url <- remote_url
      if (is.null(commit_message)) {
        commit_message <- private$format_commit_message()
      }
      private$commit_message <- commit_message
    },

    run = function() {
      private$init()
      private$fetch()
      private$commit()
      private$push()
    }
  ),

  private = list(
    path = NULL,
    branch = NULL,
    orphan = FALSE,
    remote_url = NULL,
    commit_message = NULL,

    repo = NULL,
    remote_name = "origin",

    init = function() {
      unlink(file.path(private$path, ".git"), force = TRUE, recursive = TRUE)
      private$repo <- git2r::init(private$path)

      latest_commit <- git2r::commits(git2r::repository("."), topological = FALSE, time = FALSE, n = 1L)[[1L]]
      latest_author <- latest_commit@author
      git2r::config(private$repo, user.name = latest_author@name, user.email = latest_author@email)
    },

    fetch = function() {
      remote_name <- private$remote_name

      if (remote_name %in% git2r::remotes(private$repo)) {
        git2r::remote_remove(private$repo, remote_name)
      }
      git2r::remote_add(private$repo, remote_name, private$remote_url)

      if (!private$orphan) {
        git2r::fetch(private$repo, remote_name, refspec = paste0("refs/heads/", private$branch),
                     credentials = git2r::cred_ssh_key())

        remote_branch <- git2r::branches(private$repo, "remote")[[paste0(remote_name, "/", private$branch)]]
        git2r::reset(git2r::lookup(private$repo, git2r::branch_target(remote_branch)))
      }
    },

    commit = function() {
      git2r::add(private$repo, ".")
      status <- git2r::status(private$repo, staged = TRUE, unstaged = FALSE, untracked = FALSE, ignored = FALSE)
      if (length(status$staged) > 0) {
        git2r::commit(private$repo, private$commit_message)
      } else {
        message("Nothing to commit!")
      }
    },

    push = function() {
      git2r::branch_rename(git2r::head(private$repo), private$branch)

      git2r::push(private$repo, "origin", paste0("refs/heads/", private$branch),
                  force = private$orphan,
                  credentials = git2r::cred_ssh_key())
    },

    format_commit_message = function() {
      paste0(
        "Deploy from Travis build #", Sys.getenv("TRAVIS_BUILD_NUMBER"), "\n\n",
        "Build URL: https://travis-ci.org/", Sys.getenv("TRAVIS_REPO_SLUG"), "/", Sys.getenv("TRAVIS_BUILD_ID"), "\n",
        "Commit: ", Sys.getenv("TRAVIS_COMMIT")
      )
    }
  )
)

#' @export
task_push_deploy <- PushDeploy$new
