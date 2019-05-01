InstallDeps <- R6Class(
  "InstallDeps",
  inherit = TicStep,

  public = list(
    initialize = function(repos = repo_default()) {
      private$repos <- repos
    },

    prepare = function() {
      verify_install("remotes")
    },

    run = function() {
      remotes::install_deps(dependencies = TRUE, repos = private$repos)
    }
  ),

  private = list(
    repos = NULL
  )
)

#' Step: Install packages
#'
#' @description
#' These steps are useful if your CI run needs additional packages.
#' Usually they are declared as dependencies in your `DESCRIPTION`,
#' but it is also possible to install dependencies manually.
#'
#' A `step_install_deps()` step installs all package dependencies declared in
#' `DESCRIPTION`, using [remotes::install_deps()].
#' This includes upgrading outdated packages.
#'
#' @param repos CRAN-like repositories to install from, defaults to
#'   [repo_default()].
#' @family steps
#' @export
#' @name step_install_pkg
step_install_deps <- function(repos = repo_default()) {
  InstallDeps$new(repos = repos)
}







InstallCRAN <- R6Class(
  "InstallCRAN",
  inherit = TicStep,

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
        message(paste0("Package ", private$package, " already installed."))
      }
    }
  ),
  private = list(
    package = NULL,
    install_args = NULL
  )
)

#' @description
#' A `step_install_cran()` step installs one package from CRAN via [install.packages()],
#' but only if it's not already installed.
#'
#' @param package Package(s) to install
#' @param ... Passed on to `install.packages()` or `remotes::install_github()`.
#' @export
#' @rdname step_install_pkg
step_install_cran <- function(package = NULL, ..., repos = repo_default()) {
  InstallCRAN$new(package = package, repos = repos, ...)
}







InstallGithub <- R6Class(
  "InstallGithub",
  inherit = TicStep,

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
#' @export
#' @rdname step_install_pkg
step_install_github <- function(repo = NULL, ...) {
  InstallGithub$new(repo = repo, ...)
}
