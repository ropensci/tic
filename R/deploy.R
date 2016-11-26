#' @export
before_script <- function(stages = load_from_file()) {

  steps <- get_stage_steps(stages)
  exec_before_script(steps)

}

get_stage_steps <- function(stages) {
  stage_steps <- lapply(unname(stages), "[[", "get_steps")
  steps <- unlist(lapply(stage_steps, function(fun) fun()), recursive = FALSE)
  steps
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
deploy <- function(stage = load_from_file()$deploy) {
  steps <- stage$get_steps()
  run("deploy", steps)
}

#' @export
after_success <- function(stage = load_from_file()$after_success) {
  steps <- stage$get_steps()
  run("after_success", steps)
}

run <- function(stage, steps) {
  check_results <- call_check(steps, stage)

  lapply(steps[check_results], function(step) {
    step_name <- class(step)[[1L]]
    message("Running ", stage, ": ", step_name)
    step$run()
  })
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
