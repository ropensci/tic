#' Prepare all stages
#'
#' Run the `prepare()` method for all defined steps for which the
#' `check()` method returns `TRUE`.
#'
#' @param stages `[named list]`
#'   A named list of `TicStage` objects as returned by [dsl_load()],
#'   by default loaded from `tic.R`.
#'
#' @seealso [TicStep]
#' @family runners
#'
#' @export
prepare_all_stages <- function(stages = dsl_load()) {
  lapply(stages, function(stage) stage$prepare_all())
  invisible()
}

#' Run a stage
#'
#' Run the `run_all()` method for all defined steps of a stage for which the
#' `check()` method returns `TRUE`.
#'
#' @seealso [TicStep]
#' @family runners
#'
#' @param name `[string]`\cr
#'   The name of the stage to run.
#' @inheritParams prepare_all_stages
#'
#' @export
run_stage <- function(name, stages = dsl_load()) {
  stage <- stages[[name]]
  if (!is.null(stage)) {
    stage$run_all()
  }
}

#' Emulate a CI run locally
#'
#' Runs predefined [stages] similarly to Travis CI and AppVeyor.
#' The run aborts on error, the `after_failure` stage is never run.
#'
#'
#' @inheritParams run_stage
#' @export
run_all_stages <- function(stages = dsl_load()) {
  #' @details
  #' The stages are run in the following order:
  #'

  #' 1. `before_install()`
  before_install(stages)

  #' 1. `install()`
  install(stages)

  #' 1. `after_install()`
  after_install(stages)

  #' 1. `before_script()`
  before_script(stages)

  #' 1. `script()`
  script(stages)

  #' 1. `after_success()`
  after_success(stages)

  #' 1. `before_deploy()`
  before_deploy(stages)

  #' 1. `deploy()`
  deploy(stages)

  #' 1. `after_deploy()`
  after_deploy(stages)

  #' 1. `after_script()`
  after_script(stages)
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
before_install <- function(stages = dsl_load()) {
  run_stage("before_install", stages = stages)
}

#' @rdname stages
#' @export
install <- function(stages = dsl_load()) {
  run_stage("install", stages = stages)
}

#' @rdname stages
#' @export
after_install <- function(stages = dsl_load()) {
  run_stage("after_install", stages = stages)
}

#' @rdname stages
#' @export
before_script <- function(stages = dsl_load()) {
  run_stage("before_script", stages = stages)
}

#' @rdname stages
#' @export
script <- function(stages = dsl_load()) {
  run_stage("script", stages = stages)
}

#' @rdname stages
#' @export
after_success <- function(stages = dsl_load()) {
  run_stage("after_success", stages = stages)
}

#' @rdname stages
#' @export
after_failure <- function(stages = dsl_load()) {
  run_stage("after_failure", stages = stages)
}

#' @rdname stages
#' @export
before_deploy <- function(stages = dsl_load()) {
  run_stage("before_deploy", stages = stages)
}

#' @rdname stages
#' @export
deploy <- function(stages = dsl_load()) {
  run_stage("deploy", stages = stages)
}

#' @rdname stages
#' @export
after_deploy <- function(stages = dsl_load()) {
  run_stage("after_deploy", stages = stages)
}

#' @rdname stages
#' @export
after_script <- function(stages = dsl_load()) {
  run_stage("after_script", stages = stages)
}
