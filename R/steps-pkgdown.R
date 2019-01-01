#' @include steps-rcmdcheck.R
BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function(...) {
      private$pkgdown_args <- list(...)
      super$initialize()
    },

    run = function() {
      remotes::install_local(".")
      do.call(pkgdown::build_site, c(list(preview = FALSE), private$pkgdown_args))
    },

    prepare = function() {
      # magick is needed for favicon
      verify_install(c("pkgdown", "remotes", "magick"))
      super$prepare()
    }
  ),

  private = list(
    pkgdown_args = NULL
  )
)

#' Step: Build pkgdown documentation
#'
#' Builds package documentation with the \pkg{pkgdown} package.
#'
#' @param ... Passed on to `pkgdown::build_site()`
#' @family steps
#' @export
step_build_pkgdown <- function(...) {
  BuildPkgdown$new(...)
}
