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
      if (dir.exists("docs")) {
        pkgdown::clean_site()
      }
      do.call(
        pkgdown::build_site, c(list(preview = FALSE), private$pkgdown_args)
      )
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
#' Calls `pkgdown::clean_site()` and then `pkgdown::build_site(...)`.
#'
#' @inheritDotParams pkgdown::build_site
#' @family steps
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_build_pkgdown())
#'
#' dsl_get()
step_build_pkgdown <- function(...) {
  BuildPkgdown$new(...)
}
