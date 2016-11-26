#' @export
before_script <- function(steps = c(get_deploy_steps(), get_after_success_steps())) {

  steps <- parse_steps(steps)
  exec_before_script(steps)

}

exec_before_script <- function(steps) {

  # prepare() method overridden?
  prepares <- lapply(steps, "[[", "prepare")
  prepare_empty <- vlapply(prepares, identical, TicStep$public_methods$prepare)

  prepare_steps <- steps[!prepare_empty]

  check_results <- call_check(prepare_steps, "before_script")

  lapply(prepare_steps[check_results], function(step) {
    step_name <- class(step)[[1L]]
    message("Preparing: ", step_name)
    step$prepare()
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

  steps <- parse_steps(steps)
  exec_run(stage, steps)

}

exec_run <- function(stage, steps) {

  check_results <- call_check(steps, stage)

  lapply(steps[check_results], function(step) {
    step_name <- class(step)[[1L]]
    message("Running ", stage, ": ", step_name)
    step$run()
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

call_check <- function(steps, stage) {
  checks <- lapply(steps, "[[", "check")
  check_results <- vlapply(checks, do.call, args = list())

  if (any(!check_results)) {
    message("Skipping ", stage, ":")
    print(lapply(checks[!check_results], body))
  }

  check_results
}
