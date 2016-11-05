#' @export
before_script <- function(task_code = c(get_deploy_task_code(), get_after_success_task_code())) {

  tasks <- parse_task_code(task_code)

  # prepare() method overridden?
  prepares <- lapply(tasks, "[[", "prepare")
  prepare_empty <- vlapply(prepares, identical, TravisTask$public_methods$prepare)

  prepare_tasks <- tasks[!prepare_empty]

  checks <- lapply(prepare_tasks, "[[", "check")
  check_results <- vlapply(checks, do.call, args = list())

  if (any(!check_results)) {
    message("Skipping preparation:")
    print(lapply(checks[!check_results], body))
  }

  lapply(prepare_tasks[check_results], function(task) {
    task_name <- class(task)[[1L]]
    message("Preparing: ", task_name)
    task$prepare()
  })

  invisible()

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
  lapply(parsed, eval, asNamespace(utils::packageName()))
}

parse_one <- function(code) {
  as.list(parse(text = code))
}
