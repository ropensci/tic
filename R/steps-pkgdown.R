BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStep,

  public = list(
    run = function() {
      pkgdown::build_site(preview = FALSE)
    },

    prepare = function() {
      verify_install("remotes")
      if (!package_installed("pkgdown")) {
        remotes::install_github("krlmr/pkgdown@b-pkgload")
      }
    }
  )
)

#' @export
step_build_pkgdown <- BuildPkgdown$new
