RCMDcheck <- R6Class(
  "RCMDcheck", inherit = TicStep,

  public = list(
    initialize = function(warnings_are_errors = TRUE, notes_are_errors = FALSE,
                          check_args = "--no-manual", build_args = character()) {
      private$warnings_are_errors <- warnings_are_errors
      private$notes_are_errors <- notes_are_errors
      private$check_args <- check_args
      private$build_args <- build_args
    },

    run = function() {
      res <- rcmdcheck::rcmdcheck(check_args = private$check_args,
                                  build_args = private$build_args)
      saveRDS(res, "$HOME/rcmdcheck.rda")
      print(res)
      if (length(res$errors) > 0) {
        stopc("Errors found.")
      }
      if (private$warnings_are_errors && length(res$warnings) > 0) {
        stopc("Warnings found, and warnings_are_errors is set.")
      }
      if (private$notes_are_errors && length(res$notes) > 0) {
        stopc("Notes found, and notes_are_errors is set.")
      }
    },

    prepare = function() {
      verify_install("rcmdcheck")
    }
  ),

  private = list(
    warnings_are_errors = NULL,
    notes_are_errors = NULL,
    check_args = NULL,
    build_args = NULL
  )
)

#' Step: Check a package
#'
#' Check a package using \pkg{rcmdcheck}, which ultimately calls `R CMD check`.
#'
#' @param warnings_are_errors `[flag]`\cr
#'   Should warnings be treated as errors? Default: `TRUE`.
#' @param notes_are_errors `[flag]`\cr
#'   Should notes be treated as errors? Default: `FALSE`.
#' @param check_args `[character]`\cr
#'   Passed to `[rcmdcheck::rcmdcheck()]` (after splitting at spaces), default:
#'   `"--no-manual --as-cran"`.
#' @param build_args `[character]`\cr
#'   Passed to `[rcmdcheck::rcmdcheck()]`
#' @export
step_rcmdcheck <- function(warnings_are_errors = TRUE, notes_are_errors = FALSE,
                           check_args = "--no-manual --as-cran",
                           build_args = build_args) {
  RCMDcheck$new(
    warnings_are_errors = warnings_are_errors,
    notes_are_errors = notes_are_errors,
    check_args = strsplit(check_args, "[[:blank:]]+")[[1]],
    build_args = build_args
  )
}
