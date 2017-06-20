#' @export
prepare_all_stages <- function(stages = load_from_file()) {
  with_traceback(
    lapply(stages, function(stage) stage$prepare_all())
  )
  invisible()
}

#' @export
run_stage <- function(name, stages = load_from_file()) {
  stage <- stages[[name]]
  if (!is.null(stage)) {
    with_traceback(
      stage$run_all()
    )
  }
}

#' @export
before_install <- function(stages = load_from_file()) {
  run_stage("before_install", stages = stages)
}

#' @export
install <- function(stages = load_from_file()) {
  run_stage("install", stages = stages)
}

#' @export
after_install <- function(stages = load_from_file()) {
  run_stage("after_install", stages = stages)
}

#' @export
before_script <- function(stages = load_from_file()) {
  run_stage("before_script", stages = stages)
}

#' @export
script <- function(stages = load_from_file()) {
  run_stage("script", stages = stages)
}

#' @export
before_cache <- function(stages = load_from_file()) {
  run_stage("before_cache", stages = stages)
}

#' @export
after_success <- function(stages = load_from_file()) {
  run_stage("after_success", stages = stages)
}

#' @export
after_failure <- function(stages = load_from_file()) {
  run_stage("after_failure", stages = stages)
}

#' @export
before_deploy <- function(stages = load_from_file()) {
  run_stage("before_deploy", stages = stages)
}

#' @export
deploy <- function(stages = load_from_file()) {
  run_stage("deploy", stages = stages)
}

#' @export
after_deploy <- function(stages = load_from_file()) {
  run_stage("after_deploy", stages = stages)
}

#' @export
after_script <- function(stages = load_from_file()) {
  run_stage("after_script", stages = stages)
}
