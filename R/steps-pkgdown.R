BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStep,

  public = list(
    run = function() {
      withr::with_temp_libpaths({
        remotes::install_local(".")
        pkgdown::build_site(preview = FALSE)
      })
    },

    prepare = function() {
      verify_install("remotes")
      remotes::install_github("hadley/pkgdown")
    }
  )
)

#' Step: Build pkgdown documentation
#'
#' Builds package documentation with the \pkg{pkgdown} package.
#'
#' @family steps
#' @export
step_build_pkgdown <- function() {
  BuildPkgdown$new()
}
