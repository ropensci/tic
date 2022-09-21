# InstallDeps ------------------------------------------------------------------

InstallDeps <- R6Class(
  "InstallDeps",
  inherit = TicStep,
  public = list(
    initialize = function(dependencies = TRUE) {
    },
    prepare = function() {
      TRUE
    },
    run = function() {
      if (grepl("Ubuntu", Sys.info()[["version"]]) &&
        !grepl("Under development", R.version[["status"]])) {
        options(repos = c(CRAN = sprintf(
          "https://packagemanager.rstudio.com/all/__linux__/%s/latest",
          system("lsb_release -cs", intern = TRUE)
        )))
      }
      pak::local_install_dev_deps()
      startup::restart()
    }
  ),
  private = list(
    dependencies = NULL
  )
)

#' Step: Install packages
#'
#' @description
#' These steps are useful if your CI run needs additional packages.
#' Usually they are declared as dependencies in your `DESCRIPTION`,
#' but it is also possible to install dependencies manually.
#' By default, binary versions of packages are installed if possible,
#' even if the CRAN version is ahead.
#'
#' A `step_install_deps()` step installs all package dependencies declared in
#' `DESCRIPTION`, using [pak::local_install_dev_deps()].
#' This includes upgrading outdated packages.
#'
#' This step can only be used if a DESCRIPTION file is present in the repository
#' root.
#'
#' @inheritParams pak::local_install_dev_deps
#' @family steps
#' @export
#' @name step_install_pkg
#' @examples
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_install_deps())
#'
#' dsl_get()
step_install_deps <- function(dependencies = TRUE) {
  InstallDeps$new(dependencies = dependencies)
}

# InstallCRAN ------------------------------------------------------------------

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
      rlang::exec(
        pak::pkg_install,
        pkg = private$package,
        !!!private$install_args
      )
    }
  ),
  private = list(
    package = NULL,
    install_args = NULL
  )
)

#' @description
#' A `step_install_cran()` step installs one package from CRAN via
#' [install.packages()], but only if it's not already installed.
#'
#' @param package Package(s) to install
#' @param ... Passed on to `pak::pkg_install()`.
#' @export
#' @rdname step_install_pkg
#' @examples
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_install_cran("magick"))
#'
#' dsl_get()
step_install_cran <- function(package = NULL, ...) {
  InstallCRAN$new(package = package, ...)
}

# InstallGithub ----------------------------------------------------------------

InstallGitHub <- R6Class(
  "InstallGitHub",
  inherit = TicStep,
  public = list(
    initialize = function(repo, ...) {
      private$repo <- repo
      private$install_args <- list(...)
    },
    run = function() {
      do.call(
        pak::pkg_install, c(
          list(pkg = private$repo),
          private$install_args
        )
      )
    },
    prepare = function() {
      TRUE
    }
  ),
  private = list(
    repo = NULL,
    install_args = NULL
  )
)

#' @description
#' A `step_install_github()` step installs one or more packages from GitHub
#' via [pak::pkg_install()], the packages are only installed if their
#' GitHub version is different from the locally installed version.
#'
#' @param repo Package to install in the "user/repo" format.
#' @export
#' @rdname step_install_pkg
#' @examples
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_install_github("rstudio/gt"))
#'
#' dsl_get()
step_install_github <- function(repo = NULL, ...) {
  InstallGitHub$new(repo = repo, ...)
}
