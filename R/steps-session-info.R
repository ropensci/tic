SessionInfo <- R6Class(
  "SessionInfo",
  inherit = TicStep,

  public = list(
    initialize = function() {
      super$initialize()
    },

    prepare = function() {
      verify_install("sessioninfo")
      super$prepare()
    },

    run = function() {
      print(sessioninfo::session_info())
    },

    check = function() {
      !ci_is_interactive()
    }
  )
)

#' Step: Print the current Session Info
#'
#' Prints out the package information of the current session via
#' [sessioninfo::session_info()].
#'
#' @family steps
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_session_info())
#'
#' dsl_get()
step_session_info <- function() {
  SessionInfo$new()
}
