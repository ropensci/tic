BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TravisTask,

  public = list(
    initialize = function(on_branch = "master") {
      super$initialize(on_branch = on_branch)
    },

    run = function() {
      pkgdown::build_site()
    },

    prepare = function() {
      if (!requireNamespace("pkgdown", quietly = TRUE))
        devtools::install_github("hadley/pkgdown")
    }
  )
)

#' @export
task_build_pkgdown <- BuildPkgdown$new
