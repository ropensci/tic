#' @export
before_script <- function(stages = load_from_file()) {
  lapply(stages, function(stage) stage$prepare_all())
}

#' @export
deploy <- function(stage = load_from_file()$deploy) {
  if (!is.null(stage)) {
    stage$run_all()
  }
}

#' @export
after_success <- function(stage = load_from_file()$after_success) {
  if (!is.null(stage)) {
    stage$run_all()
  }
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
