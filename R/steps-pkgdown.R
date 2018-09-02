#' @include steps-rcmdcheck.R
BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStepWithPrivateLib,

  public = list(
    initialize = function(...) {
      private$pkgdown_args <- list(...)
      super$initialize()
    },

    run = function() {
      # Don't need to be super-strict when building pkgdown
      withr::with_libpaths(
        super$get_lib(), action = "prepend",
        do.call(f_build_site, c(list(preview = FALSE), private$pkgdown_args))
      )
    },

    prepare = function() {
      verify_install("pkgdown")
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
