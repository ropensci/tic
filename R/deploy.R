#' @export
prepare <- function(task_code = c(get_deploy_task_code(), get_after_success_task_code())) {
  tasks <- parse_task_code(task_code)

  lapply(tasks, function(task) {
    task_name <- class(task)[[1L]]
    # prepare() method overridden?
    if (!identical(task$prepare, TravisTask$public_methods$prepare)) {
      if (!task$check()) {
        message("Skipping ", step, " preparation: ", task_name)
      } else {
        message("Preparing deploy: ", task_name)
        task$prepare()
      }
    }
  })

}

#' @export
deploy <- function(task_code = get_deploy_task_code()) {
  run("deploy", task_code)
}

#' @export
after_success <- function(task_code = get_after_success_task_code()) {
  run("after_success", task_code)
}

run <- function(step, task_code) {
  tasks <- parse_task_code(task_code)

  lapply(tasks, function(task) {
    task_name <- class(task)[[1L]]
    if (!task$check()) {
      message("Skipping ", step, ": ", task_name)
    } else {
      message("Running ", step, ": ", task_name)
      task$run()
    }
  })

}

#' @export
get_deploy_task_code <- function() {
  Sys.getenv("RTRAVIS_DEPLOY_TASKS")
}

#' @export
get_after_success_task_code <- function() {
  Sys.getenv("RTRAVIS_AFTER_SUCCESS_TASKS")
}

parse_task_code <- function(task_code) {
  parsed <- Reduce(c, lapply(task_code, parse_one), list())
  names(parsed) <- vapply(parsed, deparse, nlines = 1L, character(1L))
  lapply(parsed, eval)
}

parse_one <- function(code) {
  as.list(parse(text = code))
}
