BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TicStep,

  public = list(
    initialize = function(...) {
      private$pkgdown_args <- list(...)
    },

    run = function() {
      do.call(pkgdown::build_site, c(list(preview = FALSE), private$pkgdown_args))
    },

    prepare = function() {
      verify_install("pkgdown")
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
