RunCovr <- R6Class(
  "RunCovr", inherit = TravisStep,

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
