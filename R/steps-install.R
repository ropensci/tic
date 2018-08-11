InstallCRAN <- R6Class(
  "InstallCRAN", inherit = TicStep,

  public = list(
    initialize = function(package, ...) {
      stopifnot(length(package) == 1)
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

#' Step: Install packages
#'
#' @description
#' These steps are useful if your CI run needs packages which are not declared
#' as dependencies in your `DESCRIPTION`.
#' Usually you should declare these dependencies, but this may not always be desired.
#'
#' A `step_install_cran()` step installs one package from CRAN via [install.packages()],
#' but only if it's not already installed.
#'
#' @param package Package(s) to install
#' @param ... Passed on to `install.packages()`.
#' @family steps
#' @export
#' @name step_install_pkg
step_install_cran <- function(package = NULL, ...) {
  InstallCRAN$new(package = package, ...)
}







InstallGithub <- R6Class(
  "InstallGithub", inherit = TicStep,

  public = list(
    initialize = function(repo, ...) {
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

#' @description
#' A `step_install_github()` step installs one or more packages from GitHub
#' via [remotes::install_github()], the packages are only installed if their
#' GitHub version is different from the locally installed version.
#'
#' @param repo Package to install in the "user/repo" format.
#' @param ... Passed on to `remotes::install_github()`.
#' @family steps
#' @export
#' @rdname step_install_pkg
step_install_github <- function(repo = NULL, ...) {
  InstallGithub$new(repo = repo, ...)
}
