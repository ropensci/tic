#' @import backports
#' @import rlang
NULL

#' tic's domain-specific language
#'
#' Functions to define stages and their constitutent
#' steps.
#' The [macro]s combine several steps and assign them to relevant
#' stages.
#' See [dsl_get()] for functions to access the storage for the stages
#' and their steps.
#'
#' @name dsl
#' @aliases DSL
NULL

#' @description
#' `get_stage()` returns a `TicStage` object for a stage given by name.
#' This function can be called directly in the `tic.R` configuration file,
#' which is processed by [dsl_load()].
#'
#' @param name `[string]`\cr
#'   The name for the stage.
#' @rdname dsl
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script")
get_stage <- function(name) {
  # Initialize if necessary
  dsl_get()

  dslobj_get()$get_stage(name)
}

#' @description
#' `add_step()` adds a step to a stage, see [step_hello_world()]
#' and the links therein for available steps.
#'
#' @param stage `[TicStage]`\cr
#'   A `TicStage` object as returned by `get_stage()`.
#' @param step `[function]`\cr
#'   An object of class [TicStep], usually created by functions
#'   with the `step_` prefix like [step_hello_world()].
#' @rdname dsl
#' @export
#' @examples
#'
#' get_stage("script") %>%
#'   add_step(step_hello_world())
#'
#' get_stage("script")
add_step <- function(stage, step) {
  step_quo <- enquo(step)

  tryCatch(
    step <- eval_tidy(step_quo),
    error = function(e) {
      stop("Error evaluating the step argument of add_step(), expected an object of class TicStep.\n",
        "Original error: ", conditionMessage(e),
        call. = FALSE
      )
    }
  )

  stopifnot(inherits(step, "TicStep"))

  stage$add_step(step, quo_text(step_quo))
}

#' @description
#' `add_code_step()` is a shortcut for `add_step(step_run_code(...))`.
#'
#' @export
#' @inheritParams step_run_code
#' @rdname dsl
#' @examples
#'
#' get_stage("script") %>%
#'   add_code_step(print("Hi!"))
#'
#' get_stage("script")
add_code_step <- function(stage, call = NULL, prepare_call = NULL) {
  call_expr <- enexpr(call)
  prepare_call_expr <- enexpr(prepare_call)

  if (is.null(prepare_call_expr)) {
    step <- quo(step_run_code(!!call_expr))
  } else {
    step <- quo(step_run_code(!!call_expr, !!prepare_call_expr))
  }
  add_step(stage, !!step)
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

TicDSL <- R6Class(
  "TicDSL",
  public = list(
    initialize = function() {
      stage_names <- c(
        "before_install",
        "install",
        "after_install",
        "before_script",
        "script",
        "after_success",
        "after_failure",
        "before_deploy",
        "deploy",
        "after_deploy",
        "after_script"
      )

      private$stages <- lapply(stats::setNames(nm = stage_names), TicStage$new)
    },

    get_stage = function(name) {
      stage <- self$get_stages()[[name]]
      if (is.null(stage)) {
        stop("Unknown stage ", name, ".", call. = FALSE)
      }
      stage
    },

    get_stages = function() {
      new_stages(private$stages)
    }
  ),

  private = list(
    stages = NULL
  )
)
