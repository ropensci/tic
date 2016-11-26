RunCovr <- R6Class(
  "RunCovr", inherit = TicStep,

  public = list(
    run = function() {
      covr::codecov()
    },

    prepare = function() {
      if (!requireNamespace("covr", quietly = TRUE))
        install.packages("covr")
    }
  )
)

#' @export
step_run_covr <- RunCovr$new
