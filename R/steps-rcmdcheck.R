TicStepWithPrivateLib <- R6Class(
  "TicStepWithPrivateLib", inherit = TicStep,

  public = list(
    initialize = function() {
      private$lib <- file.path(.libPaths()[[1]], "tic-lib")
      dir.create(private$lib, showWarnings = FALSE)
    },

    prepare = function() {
      verify_install("remotes")

      f_install_deps <- remotes::install_deps
      withr::with_libpaths(
        private$lib, action = "replace",
        {
          f_install_deps(dependencies = TRUE)
          utils::update.packages(ask = FALSE)
        }
      )
    }
  ),

  private = list(
    lib = NULL
  )
)

RCMDcheck <- R6Class(
  "RCMDcheck", inherit = TicStepWithPrivateLib,

  public = list(
    initialize = function(warnings_are_errors = TRUE, notes_are_errors = FALSE,
                          args = "--no-manual") {
      private$warnings_are_errors <- warnings_are_errors
      private$notes_are_errors <- notes_are_errors
      private$args <- args

      super$initialize()
    },

    run = function() {
      f_rcmdcheck <- rcmdcheck::rcmdcheck
      withr::with_libpaths(
        private$lib, action = "replace",
        res <- f_rcmdcheck(args = private$args)
      )
      print(res)
      if (length(res$errors) > 0) {
        stopc("Errors found.")
      }
      if (private$warnings_are_errors && length(res$warnings) > 0) {
        stopc("Warnings found, and `warnings_are_errors` is set.")
      }
      if (private$notes_are_errors && length(res$notes) > 0) {
        stopc("Notes found, and `notes_are_errors` is set.")
      }
    },

    prepare = function() {
      verify_install("rcmdcheck")
      super$prepare()
    }
  ),

  private = list(
    warnings_are_errors = NULL,
    notes_are_errors = NULL,
    args = NULL,

    lib = NULL
  )
)

#' Step: Check a package
#'
#' Check a package using \pkg{rcmdcheck}, which ultimately calls `R CMD check`.
#' The preparation consists of installing package dependencies
#' via [remotes::install_deps()] with `dependencies = TRUE`,
#' and updating all packages.
#'
#' This step uses a dedicated library,
#' a subdirectory `tic-pkg` of the current user library
#' (the first element of [.libPaths()]),
#' for the checks.
#' This is done to minimize conflicts between dependent packages
#' and packages that are required for running the various steps.
#'
#' @param warnings_are_errors `[flag]`\cr
#'   Should warnings be treated as errors? Default: `TRUE`.
#' @param notes_are_errors `[flag]`\cr
#'   Should notes be treated as errors? Default: `FALSE`.
#' @param args `[character]`\cr
#'   Passed to `[rcmdcheck::rcmdcheck()]` (after splitting at spaces), default:
#'   `"--no-manual --as-cran"`.
#' @export
step_rcmdcheck <- function(warnings_are_errors = TRUE, notes_are_errors = FALSE,
                           args = "--no-manual --as-cran") {
  RCMDcheck$new(
    warnings_are_errors = warnings_are_errors,
    notes_are_errors = notes_are_errors,
    args = strsplit(args, "[[:blank:]]+")[[1]]
  )
}
