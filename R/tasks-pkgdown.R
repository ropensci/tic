BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TravisTask,

  public = list(
    initialize = function(branch = "master") {
      private$branch <- branch
    },

    run = function() {
      pkgdown::build_site()
    },

    prepare = function() {
      if (!requireNamespace("pkgdown", quietly = TRUE))
        devtools::install_github("hadley/pkgdown")
    },

    check = function() {
      Sys.getenv("TRAVIS_BRANCH") == private$branch
    }
  ),

  private = list(
    branch = NULL
  )
)

#' @export
task_build_pkgdown <- BuildPkgdown$new
