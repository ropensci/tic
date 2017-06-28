#' Prepare all stages
#'
#' Run the `prepare()` method for all defined steps for which the
#' `check()` method returns `TRUE`.
#'
#' @param stages `[named list]`
#'   A named list of `Stage` objects as returned by [load_from_file()],
#'   by default loaded from `tic.R`.
#'
#' @seealso [TicStep]
#' @family runners
#'
#' @export
prepare_all_stages <- function(stages = load_from_file()) {
  with_traceback(
    lapply(stages, function(stage) stage$prepare_all())
  )
  invisible()
}

#' Run a stage
#'
#' Run the `prepare()` method for all defined steps of a stage for which the
#' `check()` method returns `TRUE`.
#'
#' @seealso [TicStep]
#' @family runners
#'
#' @inheritParams prepare_all_stages
#'
#' @export
run_stage <- function(name, stages = load_from_file()) {
  stage <- stages[[name]]
  if (!is.null(stage)) {
    stage$run_all()
  }
}

#' Predefined stages
#'
#' Stages available in both Travis CI and AppVeyor, for which shortcuts
#' have been defined. All these functions call [run_stage()] with the
#' corresponding stage name.
#'
#' @inheritParams run_stage
#' @name stages
NULL

#' @rdname stages
#' @export
before_install <- function(stages = load_from_file()) {
  run_stage("before_install", stages = stages)
}

#' @rdname stages
#' @export
install <- function(stages = load_from_file()) {
  run_stage("install", stages = stages)
}

#' @rdname stages
#' @export
after_install <- function(stages = load_from_file()) {
  run_stage("after_install", stages = stages)
}

#' @rdname stages
#' @export
before_script <- function(stages = load_from_file()) {
  run_stage("before_script", stages = stages)
}

#' @rdname stages
#' @export
script <- function(stages = load_from_file()) {
  run_stage("script", stages = stages)
}

#' @rdname stages
#' @export
before_cache <- function(stages = load_from_file()) {
  run_stage("before_cache", stages = stages)
}

#' @rdname stages
#' @export
after_success <- function(stages = load_from_file()) {
  run_stage("after_success", stages = stages)
}

#' @rdname stages
#' @export
after_failure <- function(stages = load_from_file()) {
  run_stage("after_failure", stages = stages)
}

#' @rdname stages
#' @export
before_deploy <- function(stages = load_from_file()) {
  run_stage("before_deploy", stages = stages)
}

#' @rdname stages
#' @export
deploy <- function(stages = load_from_file()) {
  run_stage("deploy", stages = stages)
}

#' @rdname stages
#' @export
after_deploy <- function(stages = load_from_file()) {
  run_stage("after_deploy", stages = stages)
}

#' @rdname stages
#' @export
after_script <- function(stages = load_from_file()) {
  run_stage("after_script", stages = stages)
}
