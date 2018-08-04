InstallCRAN <- R6Class(
  "InstallCRAN", inherit = TicStep,

  public = list(
    initialize = function(package = NULL, ...) {
      private$package <- package
      private$install_args <- list(...)
    },
    run = function() {

      if (length(find.package(private$package, quiet = TRUE)) == 0) {

        do.call(install.packages, c(list(pkg = private$package), private$install_args))

      } else {
        message(glue::glue("Package '{private$package}' already installed."))
      }
    }
  ),
  private = list(
    package = NULL,
    install_args = NULL
  )
)

#' Step: Install packages from Github
#'
#' Install one or more packages from Github
#'
#' @param package Package to install
#' @param ... Passed on to `base::install.packages()`
#' @family steps
#' @export
step_install_cran <- function(repo = NULL, ...) {
  InstallCRAN$new(repo = repo, ...)
}

InstallGithub <- R6Class(
  "InstallGithub", inherit = TicStep,

  public = list(
    initialize = function(repo = NULL, ...) {
      private$repo <- repo
      private$install_args <- list(...)
    },
    run = function() {
      do.call(remotes::install_github, c(list(repo = private$repo), private$install_args))
    },
    prepare = function() {
      verify_install("remotes")
    }
  ),
  private = list(
    repo = NULL,
    install_args = NULL
  )
)

#' Step: Install packages
#'
#' Install a package from CRAN if its not already installed.
#'
#' @param repo Package to install in the "user/repo" format.
#' @param ... Passed on to `remotes::install_github()`.
#' @family steps
#' @export
step_install_github <- function(repo = NULL, ...) {
  InstallGithub$new(repo = repo, ...)
}
