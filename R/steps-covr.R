RunCovr <- R6Class(
  "RunCovr", inherit = TicStep,

  public = list(
    initialize = function(...) {
      private$args <- list(...)
    },

    run = function() {
      do.call(covr::codecov, args)
    },

    prepare = function() {
      if (!requireNamespace("covr", quietly = TRUE))
        install.packages("covr")
    }
  ),

  private = list(
    args = NULL
  )
)

#' @export
step_run_covr <- RunCovr$new
