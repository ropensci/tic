BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStep,

  public = list(
    run = function() {
      devtools::install(".")
      pkgdown::build_site()
    },

    prepare = function() {
      if (!requireNamespace("pkgdown", quietly = TRUE))
        devtools::install_github("hadley/pkgdown")
    }
  )
)

#' @export
step_build_pkgdown <- BuildPkgdown$new
