#' @importFrom R6 R6Class
#' @export
TicStep <- R6Class(
  "TicStep",
  cloneable = FALSE,

  public = list(
    run = function() {
      stop("Please override the run() method to do something useful.", call. = FALSE)
    },
    prepare = function() {},
    check = function() TRUE
  )
)

HelloWorld <- R6Class(
  "HelloWorld", inherit = TicStep,

  public = list(
    run = function() {
      print("Hello, world!")
    }
  )
)

#' @export
step_hello_world <- HelloWorld$new
