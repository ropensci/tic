RunCode <- R6Class(
  "RunCode", inherit = TicStep,

  public = list(
    initialize = function(call) {
      call <- substitute(call)
      private$call <- call
      private$seed <- 123
    },

    run = function() {
      set.seed(private$seed)
      eval(private$call, envir = .GlobalEnv)
    },

    prepare = function() {
      func_name <- private$call[[1]]
      if (is.call(func_name) && func_name[[1]] == quote(`::`)) {
        pkg_name <- as.character(func_name[[2]])
        verify_install(pkg_name)
      }
    }
  ),

  private = list(
    call = NULL,
    seed = NULL
  )
)

#' Step: Run arbitrary code
#'
#' Captures the expression and executes it when running the step.
#' If the top-level expression is a qualified function call (of the format
#' `package::fun()`), the package is installed during preparation.
#'
#' @param call `[call]\cr
#'   An arbitrary expression.
#'
#' @family steps
#' @examples
#' step_run_code(update.packages(ask = FALSE))
#'
#' # Will install covr from CRAN during preparation:
#' step_run_code(covr::codecov())
#' @export
step_run_code <- function(call) {
  RunCode$new(call)
}
