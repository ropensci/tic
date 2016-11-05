#' @importFrom R6 R6Class
#' @export
TravisTask <- R6Class(
  "TravisTask",
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
  "HelloWorld", inherit = TravisTask,

  public = list(
    run = function() {
      print("Hello, world!")
    }
  )
)

#' @export
task_hello_world <- HelloWorld$new
