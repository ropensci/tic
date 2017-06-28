BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStep,

  public = list(
    run = function() {
      pkgdown::build_site(preview = FALSE)
    },

    prepare = function() {
      verify_install("remotes")
      remotes::install_github("hadley/pkgdown")
    }
  )
)

#' @export
step_build_pkgdown <- BuildPkgdown$new
