TicStepWithPackageDeps <- R6Class(
  "TicStepWithPackageDeps", inherit = TicStep,

  public = list(
    initialize = function() {},

    prepare = function() {
      verify_install("remotes")

      remotes::install_deps(dependencies = TRUE)

      # Using a separate library for "build dependencies"
      # (which might well be ahead of CRAN)
      # works very poorly with custom steps that are not aware
      # of this shadow library.
      inst <- installed.packages()
      installed_pkg <- rownames(inst)
      is_priority <- inst[, "Priority"] %in% c("base", "recommended")
      priority_pkg <- installed_pkg[is_priority]
      pkg_to_update <- setdiff(installed_pkg, priority_pkg)
      remotes::update_packages(pkg_to_update)
    }
  ),
)

RCMDcheck <- R6Class(
  "RCMDcheck", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function(warnings_are_errors = NULL, notes_are_errors = NULL,
                          args = c("--no-manual", "--as-cran"),
                          build_args = "--force", error_on = "warning",
                          repos = getOption("repos"), timeout = Inf) {

      if (!is.null(notes_are_errors)) {
        note_once('`notes_are_errors` is deprecated, please use `error_on = "note"`')
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
      res <- rcmdcheck::rcmdcheck(args = private$args,
                                  build_args = private$build_args,
                                  error_on = "never",
                                  repos = private$repos,
                                  timeout = private$timeout
                                  )

      print(res)
      if (length(res$errors) > 0) {
        stopc("Errors found.")
      }
      if (private$error_on == "warning" && length(res$warnings) > 0) {
        stopc('Warnings found, and `errors_on = "warning"` is set.')
      }
      if (private$error_on == "notes" && length(res$notes) > 0) {
        stopc('Notes found, and `errors_on = "note"` is set.')
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
#' @param args `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `c("--no-manual", "--as-cran")`.
#' @param build_args `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `"--force"`.
#' @param error_on `[character]`\cr
#'   Whether to throw an error on R CMD check failures. Note that the check is
#'   always completed (unless a timeout happens), and the error is only thrown
#'   after completion. If "never", then no errors are thrown. If "error", then
#'   only ERROR failures generate errors. If "warning", then WARNING failures
#'   generate errors as well. If "note", then any check failure generated an
#'   error.
#' @param repos `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `getOption("repos")`.
#' @param timeout `[numeric]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `Inf`.
#' @export
step_rcmdcheck <- function(...,
                           warnings_are_errors = NULL, notes_are_errors = NULL,
                           args = c("--no-manual", "--as-cran"),
                           build_args = "--force", error_on = "warning",
                           repos = getOption("repos"), timeout = Inf) {
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
