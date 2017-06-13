WriteTextFile <- R6Class(
  "WriteTextFile", inherit = TicStep,

  public = list(
    initialize = function(..., path) {
      private$contents <- c(...)
      private$path <- path
    },

    run = function() {
      dir.create(dirname(private$path), recursive = TRUE)
      writeLines(private$contents, private$path)
    },

    check = function() {
      !ci()$is_interactive
    }
  ),

  private = list(
    contents = NULL,
    path = NULL
  )
)

#' @export
step_write_text_file <- WriteTextFile$new
