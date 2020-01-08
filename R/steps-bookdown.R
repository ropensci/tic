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
#' @examples
#' \dontrun{
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_build_bookdown("."))
#'
#' dsl_get()
#' }
step_build_bookdown <- function(...) {
  if (interactive()) {
    stop("step_* functions should only be used in tic.R and not interactively.")
  }
  BuildBookdown$new(...)
}
