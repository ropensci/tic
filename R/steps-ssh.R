# AddToKnownHosts --------------------------------------------------------------

# This code can only run as part of a CI run
# nocov start

AddToKnownHosts <- R6Class(
  "AddToKnownHosts",
  inherit = TicStep,
  public = list(
    initialize = function(host = "github.com") {
      private$host <- host
    },
    run = function() {
      cli_text("{.fun step_add_to_known_hosts}: Running ssh-keyscan for
               {private$host}.")
      keyscan_result <- system2(
        "ssh-keyscan",
        c("-H", shQuote(private$host)),
        stdout = TRUE
      )
      cat(keyscan_result, "\n", sep = "")

      known_hosts_path <- file.path("~", ".ssh", "known_hosts")
      dir.create(
        dirname(known_hosts_path),
        showWarnings = FALSE, recursive = TRUE
      )
      cli_text("Adding to {known_hosts_path}.")
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
#' @examples
#' dsl_init()
#'
#' get_stage("before_deploy") %>%
#'   add_step(step_add_to_known_hosts("gitlab.com"))
#'
#' dsl_get()
step_add_to_known_hosts <- function(host = "github.com") {
  AddToKnownHosts$new(host = host)
}

# InstallSSHKeys ---------------------------------------------------------------

InstallSSHKeys <- R6Class(
  "InstallSSHKeys",
  inherit = TicStep,
  public = list(
    initialize = function(private_key_name = "TIC_DEPLOY_KEY") {
      # for backward comp, if "id_rsa" exists we take this key
      private$private_key_name <- compat_ssh_key(private_key_name = private_key_name) # nolint
    },
    run = function() {
      private_key_name <- private$private_key_name

      deploy_key_path <- file.path("~", ".ssh", private_key_name)
      dir.create(
        dirname(deploy_key_path),
        recursive = TRUE, showWarnings = FALSE
      )
      cli_text("{.fun step_install_ssh_keys}:
               Writing deploy key to {.file {deploy_key_path}}.")
      if (file.exists(deploy_key_path)) {
        cli_text("Not overwriting existing SSH key.")
        return()
      }
      writeLines(
        rawToChar(openssl::base64_decode(Sys.getenv(private_key_name))),
        deploy_key_path
      )

      Sys.chmod(file.path("~", ".ssh", private_key_name), "600")

      # set the ssh command which which git should use including the key name
      git2r::config(
        core.sshCommand = sprintf(
          paste0(
            "ssh ",
            "-i ~/.ssh/%s -F /dev/null ",
            "-o LogLevel=error"
          ),
          private_key_name
        ),
        global = TRUE
      )
    },
    prepare = function() {
      verify_install("openssl")
    },
    check = function() {

      # only if non-interactive and TIC_DEPLOY_KEY env var is available
      if (!ci_is_interactive()) {
        if (!ci_can_push(private$private_key_name)) {
          cli_alert_danger("{.fun step_install_ssh_keys}: Deployment was
          requested but the build is not able to deploy.
          We checked for env var {.var {private$private_key_name}}
          but could not find it as an env var in the current build.
          Double-check if it exists.
          Calling {.fun tic::use_ghactions_deploy} may help resolving issues.",
            wrap = TRUE
          )
          stopc("This build cannot deploy to GitHub.")
        }
        TRUE
      } else {
        FALSE
      }
    }
  ),
  private = list(
    private_key_name = NULL
  )
)

#' Step: Install an SSH key
#'
#' Writes a private SSH key encoded in an environment variable
#' to a file in `~/.ssh`.
#' Only run in non-interactive settings and if the environment variable
#' exists and is non-empty.
#' [use_ghactions_deploy()] and [use_tic()] functions encode a private key as an
#' environment variable for use with this function.
#'
#' @template private_key_name
#'
#' @family steps
#' @seealso [use_tic()], [use_ghactions_deploy()]
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("before_deploy") %>%
#'   add_step(step_install_ssh_keys())
#'
#' dsl_get()
step_install_ssh_keys <- function(private_key_name = "TIC_DEPLOY_KEY") {
  private_key_name <- compat_ssh_key(private_key_name = private_key_name)
  InstallSSHKeys$new(private_key_name = private_key_name)
}

# TestSSH ----------------------------------------------------------------------

TestSSH <- R6Class(
  "TestSSH",
  inherit = TicStep,
  public = list(
    initialize = function(url = "git@github.com",
                          verbose = "",
                          private_key_name = "TIC_DEPLOY_KEY") {
      private_key_name <- compat_ssh_key(private_key_name = private_key_name)
      private$url <- url
      private$verbose <- verbose
      private$private_key_name <- private_key_name
    },
    run = function() {
      cli_text("{.fun step_test_ssh}: Trying to ssh into {private$url}")
      cli_text("{.fun step_test_ssh}: Using command: ssh -i ~/.ssh/{private$private_key_name} -o LogLevel=error {private$url} {private$verbose}")
      # suppress the warning about adding the IP to .ssh/known_hosts

      # FIXME: This command freezes Windows builds on GHA during deployment.
      if (Sys.info()[["sysname"]] != "Windows") {
        system2("ssh", c(
          "-o", "LogLevel=error",
          "-i", file.path("~", ".ssh", private$private_key_name),
          private$url, private$verbose
        ))
      }
    }
  ),
  private = list(
    url = NULL,
    verbose = NULL,
    private_key_name = NULL
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
#'   Verbosity, by default `""`. Use `-v` or `"-vvv"` for more verbosity.
#' @inheritParams step_install_ssh_keys
#' @family steps
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_test_ssh(verbose = "-vvv"))
#'
#' dsl_get()
step_test_ssh <- function(url = "git@github.com",
                          verbose = "",
                          private_key_name = "TIC_DEPLOY_KEY") {
  TestSSH$new(url = url, verbose = verbose, private_key_name = private_key_name)
}

# SetupSSH ---------------------------------------------------------------------

SetupSSH <- R6Class(
  "SetupSSH",
  inherit = TicStep,
  public = list(
    initialize = function(private_key_name = "TIC_DEPLOY_KEY",
                          host = "github.com",
                          url = paste0("git@", host),
                          verbose = "") {
      private$install_ssh_keys <- step_install_ssh_keys(private_key_name = private_key_name) # nolint
      private$add_to_known_hosts <- step_add_to_known_hosts(host = host)
      private$test_ssh <- step_test_ssh(
        url = url, verbose = verbose,
        private_key_name = private_key_name
      )
    },
    prepare = function() {
      verify_install("git2r")
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
        cli_alert_info("{.fun SetupSSH$check}: {.fun install_ssh_keys} failed.")
        return(FALSE)
      }
      if (!private$add_to_known_hosts$check()) {
        cli_alert_info("{.fun SetupSSH$check}: {.fun add_to_known_hosts} failed.") # nolint
        return(FALSE)
      }
      if (!private$test_ssh$check()) {
        cli_alert_info("{.fun SetupSSH$check}: {.fun test_ssh} failed.")
        return(FALSE)
      }
      cli_alert_success("{.fun step_setup_ssh} Everything ok.")
      return(TRUE)
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
#' [use_tic()] encodes a private key as an environment variable for use with
#' this function.
#'
#' @inheritParams step_install_ssh_keys
#' @inheritParams step_add_to_known_hosts
#' @inheritParams step_test_ssh
#'
#' @family steps
#'
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_setup_ssh(host = "gitlab.com"))
#'
#' dsl_get()
step_setup_ssh <- function(private_key_name = "TIC_DEPLOY_KEY",
                           host = "github.com",
                           url = paste0("git@", host),
                           verbose = "") {
  SetupSSH$new(
    private_key_name = private_key_name, host = host,
    url = url, verbose = verbose
  )
}

compat_ssh_key <- function(private_key_name) {
  # for backward comp, if "id_rsa" exists we take this key
  if (ci_has_env("id_rsa") && !ci_has_env(private_key_name)) {
    private_key_name <- "id_rsa"
  }
  private_key_name
}

# This code can only run as part of a CI run
# nocov end
