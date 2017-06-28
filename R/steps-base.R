#' The base class for all steps
#'
#' Override this class to create a new step.
#'
#' @importFrom R6 R6Class
#' @export
TicStep <- R6Class(
  #' @section Methods:
  #' \describe{
  "TicStep",
  cloneable = FALSE,

  public = list(
    run = function() {
      #' \item{`run`}{
      #'   This method must be overridden, it is called when running the stage
      #'   to which a step has been added.
      #' }
      stopc("Please override the run() method to do something useful.")
    },
    prepare = function() {
      #' \item{`prepare`}{
      #'   This method is called when preparing the stage
      #'   to which a step has been added.
      #'   Override this method to install any R packages your step might need,
      #'   because this allows them to be cached for subsequential runs.
      #' }
    },
    check = function() {
      #' \item{`check`}{
      #'   This method determines if a step is prepared and run.
      #'   Return `FALSE` if conditions for running this step are not met.
      #' }
      TRUE
    }
  )
  #' }
)

HelloWorld <- R6Class(
  "HelloWorld", inherit = TicStep,

  public = list(
    run = function() {
      print("Hello, world!")
    }
  )
)

#' Step: Hello World!
#'
#' Prints "Hello World!" to the console.
#'
#' @family steps
#' @export
step_hello_world <- HelloWorld$new
