WriteTextFile <- R6Class(
  "WriteTextFile",
  inherit = TicStep,

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
      !ci_is_interactive()
    }
  ),

  private = list(
    contents = NULL,
    path = NULL
  )
)

#' Step: Write a text file
#'
#' Creates a text file with arbitrary contents
#'
#' @param ... `[character]`\cr
#'   Contents of the text file.
#' @param path `[string]`\cr
#'   Path to the new text file.
#'
#' @family steps
#' @export
#' @examples
#' \dontrun{
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_write_text_file("Hi!", path = "hello.txt"))
#'
#' dsl_get()
#' }
step_write_text_file <- function(..., path) {
  if (interactive()) {
    stop("step_* functions should only be used in tic.R and not interactively.")
  }
  WriteTextFile$new(..., path = path)
}
