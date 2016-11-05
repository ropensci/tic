#' @export
before_script <- function(steps = c(get_deploy_steps(), get_after_success_steps())) {

  tasks <- parse_steps(steps)
  exec_before_script(tasks)

}

exec_before_script <- function(tasks) {

  # prepare() method overridden?
  prepares <- lapply(tasks, "[[", "prepare")
  prepare_empty <- vlapply(prepares, identical, TravisTask$public_methods$prepare)

  prepare_tasks <- tasks[!prepare_empty]

  check_results <- call_check(prepare_tasks, "before_script")

  lapply(prepare_tasks[check_results], function(task) {
    task_name <- class(task)[[1L]]
    message("Preparing: ", task_name)
    task$prepare()
  })

  invisible()

}

#' @export
deploy <- function(steps = get_deploy_steps()) {
  run("deploy", steps)
}

#' @export
after_success <- function(steps = get_after_success_steps()) {
  run("after_success", steps)
}

run <- function(stage, steps) {

  tasks <- parse_steps(steps)
  exec_run(stage, tasks)

}

exec_run <- function(stage, tasks) {

  check_results <- call_check(tasks, stage)

  lapply(tasks[check_results], function(task) {
    task_name <- class(task)[[1L]]
    message("Running ", stage, ": ", task_name)
    task$run()
  })

}

#' @export
get_after_success_steps <- function() {
  run_tic()$after_success
}

#' @export
get_deploy_steps <- function() {
  run_tic()$deploy
}

parse_steps <- function(steps) {
  steps <- coerce_steps(steps)
  valid_steps <- get_valid_steps(steps)
  tasks <- create_tasks(valid_steps)
  tasks
}

coerce_steps <- function(steps) {
  steps
}

get_valid_steps <- function(steps) {
  correct_branch <- get_correct_branch(steps)
  env_set <- get_env_set(steps)
  steps[correct_branch & env_set]
}

get_correct_branch <- function(steps) {
  on_branch <- lapply(steps, "[[", "on_branch")
  vlapply(on_branch, match_branch)
}

get_env_set <- function(steps) {
  on_env <- lapply(steps, "[[", "on_env")
  is_null <- vlapply(on_env, is.null)
  ret <- rep(TRUE, length(on_env))
  ret[!is_null] <- (vcapply(on_env[!is_null], Sys.getenv) != "")
  ret
}

create_tasks <- function(steps) {
  tasks <- lapply(steps, create_task)
  names(tasks) <- vcapply(lapply(tasks, class), "[[", 1L)
  tasks
}

create_task <- function(step) {
  do.call(step$task, step$args)
}

call_check <- function(tasks, stage) {
  checks <- lapply(tasks, "[[", "check")
  check_results <- vlapply(checks, do.call, args = list())

  if (any(!check_results)) {
    message("Skipping ", stage, ":")
    print(lapply(checks[!check_results], body))
  }

  check_results
}
