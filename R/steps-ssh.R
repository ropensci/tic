AddToKnownHosts <- R6Class(
  "AddToKnownHosts", inherit = TicStep,

  public = list(
    initialize = function(host = "github.com") {
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

#' Step: Add to known hosts
#'
#' Adds a host name to the `~/.ssh/known_hosts` file to allow subsequent
#' SSH access.
#' Requires `ssh-keyscan` on the system `PATH`.
#'
#' @param host `[string]`\cr
#'   The host name to add to the `known_hosts` file, default: `github.com`.
#'
#' @family steps
#' @export
step_add_to_known_hosts <- function(host = "github.com") {
  AddToKnownHosts$new(host = host)
}

InstallSSHKeys <- R6Class(
  "InstallSSHKeys", inherit = TicStep,

  public = list(
    run = function() {
      deploy_key_path <- file.path("~", ".ssh", "id_rsa")
      dir.create(dirname(deploy_key_path), recursive = TRUE, showWarnings = FALSE)
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

#' Step: Install an SSH key
#'
#' Writes a private SSH key encoded in the `id_rsa` environment variable
#' to `~/.ssh/id_rsa`.
#' Only run in non-interactive settings and if the `id_rsa` environment variable
#' exists and is non-empty.
#'
#' @family steps
#' @seealso [travis::use_travis_deploy()], [travis::use_tic()]
#' @export
step_install_ssh_keys <- function() {
  InstallSSHKeys$new()
}

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

#' Step: Test SSH connection
#'
#' Establishes an SSH connection.
#' This step doesn't fail if the connection cannot be established,
#' but prints verbose output by default.
#'
#' @param host `[string]`\cr
#'   URL to establish SSH connection with, by default `git@github.com`
#' @param verbose `[string]`\cr
#'   Verbosity, by default `"-v"`. Use `"-vvv"` for more verbosity.
#'
#' @family steps
#' @export
step_test_ssh <- function(host = "git@github.com", verbose = "-v") {
  TestSSH$new(host = host, verbose = verbose)
}
