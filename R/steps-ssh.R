AddToKnownHosts <- R6Class(
  "AddToKnownHosts",
  inherit = TicStep,

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
      (!ci_is_interactive()) && (Sys.which("ssh-keyscan") != "")
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
  "InstallSSHKeys",
  inherit = TicStep,

  public = list(
    initialize = function(name = "id_rsa") {
      private$name <- name
    },

    run = function() {
      name <- private$name

      deploy_key_path <- file.path("~", ".ssh", name)
      dir.create(dirname(deploy_key_path), recursive = TRUE, showWarnings = FALSE)
      message("Writing deploy key to ", deploy_key_path)
      if (file.exists(deploy_key_path)) {
        stop("Not overwriting key", call. = FALSE)
      }
      writeLines(
        rawToChar(openssl::base64_decode(Sys.getenv(name))),
        deploy_key_path
      )
      Sys.chmod(deploy_key_path, "600")
    },

    prepare = function() {
      verify_install("openssl")
    },

    check = function() {
      # only if non-interactive and id_rsa env var is available
      (!ci_is_interactive()) && (ci_can_push(private$name))
    }
  ),

  private = list(
    name = NULL
  )
)

#' Step: Install an SSH key
#'
#' Writes a private SSH key encoded in an environment variable
#' to a file in `~/.ssh`.
#' Only run in non-interactive settings and if the environment variable
#' exists and is non-empty.
#'
#' @param name `[string]`\cr
#'   Name of the environment variable and the target file, default: `"id_rsa"`.
#'
#' @family steps
#' @seealso `travis::use_travis_deploy()`, [travis::use_tic()]
#' @export
step_install_ssh_keys <- function(name = "id_rsa") {
  InstallSSHKeys$new(name = name)
}

TestSSH <- R6Class(
  "TestSSH",
  inherit = TicStep,

  public = list(
    initialize = function(url = "git@github.com", verbose = "-v") {
      private$url <- url
      private$verbose <- verbose
    },

    run = function() {
      message("Trying to ssh into ", private$url)
      system2("ssh", c(private$url, private$verbose))
    }
  ),

  private = list(
    url = NULL,
    verbose = NULL
  )
)

#' Step: Test SSH connection
#'
#' Establishes an SSH connection.
#' This step doesn't fail if the connection cannot be established,
#' but prints verbose output by default.
#' It is useful for troubleshooting deployment problems.
#'
#' @param url `[string]`\cr
#'   URL to establish SSH connection with, by default `git@github.com`
#' @param verbose `[string]`\cr
#'   Verbosity, by default `"-v"`. Use `"-vvv"` for more verbosity.
#'
#' @family steps
#' @export
step_test_ssh <- function(url = "git@github.com", verbose = "-v") {
  TestSSH$new(url = url, verbose = verbose)
}

SetupSSH <- R6Class(
  "SetupSSH",
  inherit = TicStep,

  public = list(
    initialize = function(name = "id_rsa", host = "github.com",
                          url = paste0("git@", host), verbose = "-v") {

      private$install_ssh_keys <- step_install_ssh_keys(name = name)
      private$add_to_known_hosts <- step_add_to_known_hosts(host = host)
      private$test_ssh <- step_test_ssh(url = url, verbose = verbose)
    },

    prepare = function() {
      private$install_ssh_keys$prepare()
      private$add_to_known_hosts$prepare()
      private$test_ssh$prepare()
    },

    run = function() {
      private$install_ssh_keys$run()
      private$add_to_known_hosts$run()
      private$test_ssh$run()
    },

    check = function() {
      if (!private$install_ssh_keys$check()) {
        return(FALSE)
      }
      if (!private$add_to_known_hosts$check()) {
        return(FALSE)
      }
      if (!private$test_ssh$check()) {
        return(FALSE)
      }
      TRUE
    }
  ),

  private = list(
    add_to_known_hosts = NULL,
    install_ssh_keys = NULL,
    test_ssh = NULL
  )
)

#' Step: Setup SSH
#'
#' Adds to known hosts, installs private key, and tests the connection.
#' Chaining [step_install_ssh_keys()], [step_add_to_known_hosts()]
#' and [step_test_ssh()].
#'
#' @inheritParams step_install_ssh_keys
#' @inheritParams step_add_to_known_hosts
#' @inheritParams step_test_ssh
#'
#' @family steps
#'
#' @export
step_setup_ssh <- function(name = "id_rsa", host = "github.com",
                           url = paste0("git@", host), verbose = "-v") {
  SetupSSH$new(name = name, host = host, url = url, verbose = verbose)
}
