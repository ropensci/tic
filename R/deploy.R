#' @export
prepare_deploy <- function(task_code = get_task_code()) {

  tasks <- parse_task_code(task_code)

  lapply(tasks, function(task) {
    task_name <- class(task)[[1L]]
    if (body(task$prepare) != quote({})) {
      if (!task$check()) {
        message("Skipping deploy preparation: ", task_name)
      } else {
        message("Preparing deploy: ", task_name)
        task$prepare()
      }
    }
  })

}

#' @export
deploy <- function(task_code = get_task_code()) {

  tasks <- parse_task_code(task_code)

  lapply(tasks, function(task) {
    task_name <- class(task)[[1L]]
    if (!task$check()) {
      message("Skipping deploy: ", task_name)
    } else {
      message("Deploying: ", task_name)
      task$run()
    }
  })

}

get_task_code <- function() {
  Sys.getenv("RTRAVIS_TASKS")
}

parse_task_code <- function(task_code) {
  parsed <- as.list(parse(text = task_code))
  names(parsed) <- vapply(parsed, deparse, nlines = 1L, character(1L))
  lapply(parsed, eval)
}
