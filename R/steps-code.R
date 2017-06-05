RunCode <- R6Class(
  "RunCode", inherit = TicStep,

  public = list(
    initialize = function(call) {
      call <- substitute(call)
      private$call <- call
    },

    run = function() {
      eval(private$call, envir = baseenv())
    },

    prepare = function() {
      func_name <- private$call[[1]]
      if (is.call(func_name) && func_name[[1]] == quote(`::`)) {
        pkg_name <- as.character(func_name[[2]])
        if (!requireNamespace(pkg_name, quietly = TRUE)) {
          install.packages(pkg_name)
        }
      }
    }
  ),

  private = list(
    call = NULL
  )
)

#' @export
step_run_code <- RunCode$new
