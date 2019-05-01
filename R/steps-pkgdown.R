#' @include steps-rcmdcheck.R
BuildPkgdown <- R6Class(
  "BuildPkgdown",
  inherit = TicStep,

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
      verify_install(c("pkgdown", "remotes"))
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
#' @inheritDotParams pkgdown::build_site
#' @family steps
#' @export
step_build_pkgdown <- function(...) {
  BuildPkgdown$new(...)
}
