RunCode <- R6Class(
  "RunCode", inherit = TicStep,

  public = list(
    initialize = function(call, prepare_call = NULL,
                          .call = substitute(call), .prepare_call = substitute(prepare_call)) {
      private$call <- .call
      private$prepare_call <- .prepare_call
      private$seed <- 123
    },

    run = function() {
      set.seed(private$seed)
      eval(private$call, envir = .GlobalEnv)
    },

    prepare = function() {
      # Needs to happen before auto-detection of package to be installed,
      # to allow installation of packages from nonstandard repositories
      if (!is.null(private$prepare_call)) {
        set.seed(private$seed)
        eval(private$prepare_call, envir = .GlobalEnv)
      }

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
#' An optional preparatory expression can be provided that is executed
#' during preparation.
#' If the top-level expression is a qualified function call (of the format
#' `package::fun()`), the package is installed during preparation.
#'
#' @param call `[call]`\cr
#'   An arbitrary expression executed during the stage to which this step is
#'   added.
#' @param prepare_call `[call]`\cr
#'   An optional arbitrary expression executed during preparation.
#' @family steps
#' @examples
#' step_run_code(update.packages(ask = FALSE))
#'
#' # Will install covr from CRAN during preparation:
#' step_run_code(covr::codecov())
#' @export
step_run_code <- function(call, prepare_call) {
  RunCode$new(.call = substitute(call), .prepare_call = substitute(prepare_call))
}
