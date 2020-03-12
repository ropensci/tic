#' @title The base class for all steps
#'
#' @description
#' Override this class to create a new step.
#'
#' @importFrom R6 R6Class
#' @export
TicStep <- R6Class(
  "TicStep",
  cloneable = FALSE,

  public = list(

    #' @description
    #' Create a `TicStep` object.
    initialize = function() {
    },

    #' @description
    #' This method must be overridden, it is called when running the stage
    #'   to which a step has been added.
    run = function() {
      stopc("Please override the run() method to do something useful.")
    },

    #' @description
    #' This is just a placeholder.
    #' This method is called when preparing the stage to
    #' which a step has been added. It auto-install all packages which are
    #' needed for a certain step. For example, `step_build_pkgdown()` requires
    #' the _pkgdown_ package.
    #'
    #' For `add_code_step()`, it autodetects any package calls in the form of
    #' `pkg::fun` and tries to install these packages from CRAN. If a steps
    #' `prepare_call` is not empty, the `$prepare` method is skipped for this
    #' step. This can be useful if a package should be installed from
    #' non-standard repositories, e.g. from GitHub.
    prepare = function() {
    },

    #' @description
    #' This method determines if a step is prepared and run.
    #' Return `FALSE` if conditions for running this step are not met.
    check = function() {
      TRUE
    }
  )
)

HelloWorld <- R6Class(
  "HelloWorld",
  inherit = TicStep,

  public = list(
    run = function() {
      print("Hello, world!")
    }
  )
)

#' Step: Hello, world!
#'
#' The simplest step possible: prints "Hello, world!" to the console when run,
#' does not require any preparation. This step may be useful to test a \pkg{tic}
#' setup or as a starting point when implementing a custom step.
#'
#' @family steps
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_hello_world())
#'
#' dsl_get()
step_hello_world <- function() {
  HelloWorld$new()
}
