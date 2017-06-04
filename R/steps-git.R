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
      message("Adding to ", known_hosts_path)
      write(keyscan_result, known_hosts_path, append = TRUE)
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

PushDeploy <- R6Class(
  "PushDeploy", inherit = TicStep,

  public = list(
    initialize = function(path = ".", branch = ci()$get_branch(), orphan = FALSE,
                          remote_url = paste0("git@github.com:", ci()$get_slug(), ".git"),
                          commit_message = NULL) {
      if (branch == ci()$get_branch() && orphan) {
        stop("Cannot orphan the branch that has been used for the CI run.", call. = FALSE)
      }

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
      message("Initializing Git repo at ", private$path)
      private$repo <- git2r::init(private$path)

      latest_commit <- get_head_commit(git2r::head(git2r::repository(".")))
      print(latest_commit)

      latest_author <- latest_commit@author
      print(latest_author)

      git2r::config(private$repo, user.name = latest_author@name, user.email = latest_author@email)
    },

    fetch = function() {
      remote_name <- private$remote_name
      message("Fetching from remote ", remote_name)

      if (remote_name %in% git2r::remotes(private$repo)) {
        git2r::remote_remove(private$repo, remote_name)
      }
      git2r::remote_add(private$repo, remote_name, private$remote_url)

      if (!private$orphan) {
        tryCatch(
          {
            remote_branch <- private$try_fetch()
            if (!is.null(remote_branch)) {
              git2r::reset(get_head_commit(remote_branch))
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
      private$git("fetch", remote_name, paste0("refs/heads/", private$branch))
      branches <- git2r::branches(private$repo, "remote")
      branches[[paste0(remote_name, "/", private$branch)]]
    },

    commit = function() {
      message("Committing to ", private$path)
      git2r::add(private$repo, ".")
      status <- git2r::status(private$repo, staged = TRUE, unstaged = FALSE, untracked = FALSE, ignored = FALSE)
      if (length(status$staged) > 0) {
        git2r::commit(private$repo, private$commit_message)
      } else {
        message("Nothing to commit!")
      }
    },

    push = function() {
      message("Pushing to remote")
      private$git("push", if (private$orphan) "--force", private$remote_name,
                  paste0("HEAD:", private$branch))
    },

    git = function(...) {
      args <- c(...)
      message(paste("git", paste(args, collapse = " ")))
      status <- withr::with_dir(private$path, system2("git", args))
      if (status != 0) {
        stopc("git exited with status ", status)
      }
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
step_push_deploy <- PushDeploy$new
