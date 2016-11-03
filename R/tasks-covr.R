RunCovr <- R6Class(
  "RunCovr", inherit = TravisTask,

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
task_run_covr <- RunCovr$new
