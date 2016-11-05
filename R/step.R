#' @export
step <- function(task, args = list(), on_branch = NULL, on_env = NULL) {
  structure(
    list(
      task = task,
      args = args,
      on_branch = on_branch,
      on_env = on_env
    ),
    class = "tic_step"
  )
}
