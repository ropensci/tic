RCMDcheck <- R6Class(
  "RCMDcheck",
  inherit = TicStep,

  public = list(
    initialize = function(warnings_are_errors = NULL, notes_are_errors = NULL,
                              args = c("--no-manual", "--as-cran"),
                              build_args = "--force", error_on = "warning",
                              repos = repo_default(), timeout = Inf) {
      if (!is.null(notes_are_errors)) {
        warning_once('`notes_are_errors` is deprecated, please use `error_on = "note"`')
        if (notes_are_errors) {
          error_on <- "note"
        }
      }
      else if (!is.null(warnings_are_errors)) {
        warning_once('`warnings_are_errors` is deprecated, please use `error_on = "warning"`')
        if (warnings_are_errors) {
          error_on <- "warning"
        }
      }
      private$args <- args
      private$build_args <- build_args
      private$error_on <- error_on
      private$repos <- repos
      private$timeout <- timeout

      super$initialize()
    },

    run = function() {
      res <- rcmdcheck::rcmdcheck(
        args = private$args, build_args = private$build_args,
        error_on = "never",
        repos = private$repos,
        timeout = private$timeout
      )

      print(res)
      if (length(res$errors) > 0) {
        stopc("Errors found in rcmdcheck::rcmdcheck().")
      }
      if (private$error_on == "warning" && length(res$warnings) > 0) {
        stopc('Warnings found in rcmdcheck::rcmdcheck(), and `errors_on = "warning"` is set.')
      }
      if (private$error_on == "note" && length(res$notes) > 0) {
        stopc('Notes found in rcmdcheck::rcmdcheck(), and `errors_on = "note"` is set.')
      }
    },

    prepare = function() {
      verify_install("rcmdcheck")
      super$prepare()
    }
  ),

  private = list(
    args = NULL,
    build_args = NULL,
    error_on = NULL,
    repos = NULL,
    timeout = NULL
  )
)

#' Step: Check a package
#'
#' Check a package using [rcmdcheck::rcmdcheck()],
#' which ultimately calls `R CMD check`.
#' The preparation consists of installing package dependencies
#' via [remotes::install_deps()] with `dependencies = TRUE`,
#' and updating all packages.
#'
#' @section Updating of (dependency) packages:
#' Packages shipped with the R-installation will not be updated as they will be
#' overwritten by the Travis R-installer in each build.
#' If you want these package to be updated, please add the following
#' step to your workflow: `add_code_step(remotes::update_packages(<pkg>)`.
#'
#' @param ... Ignored, used to enforce naming of arguments.
#' @param warnings_are_errors,notes_are_errors `[flag]`\cr
#'   Deprecated, use `error_on`.
#' @param error_on `[character]`\cr
#'   Whether to throw an error on R CMD check failures. Note that the check is
#'   always completed (unless a timeout happens), and the error is only thrown
#'   after completion. If "never", then no errors are thrown. If "error", then
#'   only ERROR failures generate errors. If "warning", then WARNING failures
#'   generate errors as well. If "note", then any check failure generated an
#'   error.
#' @param repos `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   [repo_default()].
#' @param timeout `[numeric]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `Inf`.
#' @export
step_rcmdcheck <- function(...,
                           warnings_are_errors = NULL, notes_are_errors = NULL,
                           args = NULL, build_args = NULL, error_on = "warning",
                           repos = repo_default(), timeout = Inf) {

  #' @param build_args `[character]`\cr
  #'   Passed to `rcmdcheck::rcmdcheck()`.\cr
  #'   Default for Travis and local runs: `"--force"`.\cr
  #'   Default for Appveyor: `c("--no--build-vignettes", "--force")`.\cr
  if (is.null(build_args)) {
    if (isTRUE(ci_on_appveyor())) {
      build_args <- c("--no--build-vignettes", "--force")
    } else {
      build_args <- "--force"
    }
  }

  #' @param args `[character]`\cr
  #'   Passed to `rcmdcheck::rcmdcheck()`.\cr
  #'   Default for Travis and local runs: `c("--no-manual", "--as-cran")`.\cr
  #'   Default for Appveyor:
  #'   `c("--no-manual", "--as-cran", "--no-vignettes", "--no-build-vignettes", "--no-multiarch")`.\cr
  if (is.null(args)) {
    if (isTRUE(ci_on_appveyor())) {
      args <- c(
        "--no-manual", "--as-cran", "--no-build-vignettes", "--no-multiarch"
      )
    } else {
      args <- c("--no-manual", "--as-cran")
    }
  }

  RCMDcheck$new(
    warnings_are_errors = warnings_are_errors,
    notes_are_errors = notes_are_errors,
    args = args,
    build_args = build_args,
    error_on = error_on,
    repos = repos,
    timeout = timeout
  )
}
