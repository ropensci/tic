BuildBookdown <- R6Class(
  "BuildBookdown", inherit = TicStep,

  public = list(
    initialize = function(...) {
      private$bookdown_args <- list(...)
      super$initialize()
    },

    run = function() {
      remotes::install_local(".")
      do.call(bookdown::render_book, private$bookdown_args)
    },

    prepare = function() {
      verify_install(c("bookdown", "remotes"))
      super$prepare()
    }
  ),

  private = list(
    bookdown_args = NULL
  )

)

#' Step: Build a bookdown book
#'
#' Check a package using [bookdown::render_book()],
#' which ultimately calls `R CMD check`.
#' The preparation consists of installing package dependencies
#' via [remotes::install_deps()] with `dependencies = TRUE`,
#' and updating all packages.
#'
#' @section Updating of (dependency) packages:
#' Packages shipped with the R-installation will not be updated as they will be
#' overwritten by the Travis R-installer in each build.
#' If you want these package to be updated, please add the following
#' step to your workflow: `add_code_step(remotes::update_packages(<pkg>)`.
#'
#' @param ... Passed on to `bookdown::render_book()`
#'
#' @export
step_build_bookdown <- function(...) {
  BuildBookdown$new(...)
}
