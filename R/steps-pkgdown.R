BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStep,

  public = list(
    run = function() {
      remotes::install_local(".")
      pkgdown::build_site(preview = FALSE)
    },

    prepare = function() {
      verify_install("remotes")
      if (!requireNamespace("pkgdown", quietly = TRUE))
        remotes::install_github("hadley/pkgdown")
    }
  )
)

#' @export
step_build_pkgdown <- BuildPkgdown$new
