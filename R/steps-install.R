# installDeps ------------------------------------------------------------------

InstallDeps <- R6Class(
  "InstallDeps",
  inherit = TicStep,

  public = list(
    initialize = function(repos = repo_default(),
                          type = getOption("pkgType")) {
      private$repos <- repos
      private$type <- type
    },

    prepare = function() {
      cli_alert_danger("The {.code step_install_deps()} step and the
                       {.code do_package_checks()} macro are only available
                       for packages.", wrap = TRUE)
      verify_install("remotes")
    },

    run = function() {
      remotes::install_deps(
        dependencies = TRUE,
        repos = private$repos,
        type = private$type,
        build = FALSE,
        INSTALL_OPTS = "--no-multiarch"
      )
    }
  ),

  private = list(
    repos = NULL,
    type = NULL
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
#' `DESCRIPTION`, using [remotes::install_deps()].
#' This includes upgrading outdated packages.
#'
#' @param repos CRAN-like repositories to install from, defaults to
#'   [repo_default()].
#' @param type Passed on to [install.packages()]. The default avoids
#'   installation from source on Windows and macOS by passing
#'   \code{\link{.Platform}$pkgType}.
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
step_install_deps <- function(repos = repo_default(),
                              type = getOption("pkgType")) {
  InstallDeps$new(repos = repos, type = type)
}

# installCRAN ------------------------------------------------------------------

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
        rlang::exec(
          install.packages,
          pkg = private$package,
          !!!private$install_args
        )
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
#' A `step_install_cran()` step installs one package from CRAN via
#' [install.packages()], but only if it's not already installed.
#'
#' @param package Package(s) to install
#' @param ... Passed on to `install.packages()` or `remotes::install_github()`.
#' @export
#' @rdname step_install_pkg
#' @examples
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_install_cran("magick"))
#'
#' dsl_get()
step_install_cran <- function(package = NULL, ...,
                              repos = repo_default(),
                              type = getOption("pkgType")) {
  InstallCRAN$new(package = package, repos = repos, ..., type = type)
}

# installGithub ----------------------------------------------------------------

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
        remotes::install_github, c(
          list(repo = private$repo),
          private$install_args
        )
      )
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
#' @examples
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_install_github("rstudio/gt"))
#'
#' dsl_get()
step_install_github <- function(repo = NULL, ...,
                                type = getOption("pkgType")) {
  InstallGitHub$new(repo = repo, ..., type = type)
}
