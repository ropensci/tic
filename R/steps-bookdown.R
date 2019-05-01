BuildBookdown <- R6Class(
  "BuildBookdown",
  inherit = TicStep,

  public = list(
    initialize = function(...) {
      private$bookdown_args <- list(...)
      super$initialize()
    },

    run = function() {
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
#' Build a bookdown book using [bookdown::render_book()].
#'
#' @inheritDotParams bookdown::render_book
#'
#' @export
step_build_bookdown <- function(...) {
  BuildBookdown$new(...)
}
