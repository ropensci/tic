Stage <- R6Class(
  "Stage",

  public = list(
    initialize = function(name) {
      private$name <- name
    },

    add_step = function(step) {
      private$steps <- c(private$steps, list(step))
      invisible(self)
    },

    add_task = function(run, check = function() TRUE, prepare = function() {}) {
      add_step(
        list(run = run, check = check, prepare = prepare)
      )
    },

    reset = function() {
      private$steps <- list()
    }
  ),

  private = list(
    name = NULL,
    steps = list()
  )
)

stages <- as.environment(
  list(
    after_success = Stage$new("after_success"),
    deploy = Stage$new("deploy")
  )
)

#' @export
get_stage <- function(name) {
  get(name, stages)
}

#' @export
add_step <- function(stage, step) {
  stage$add_step(step)
}

#' @export
add_task <- function(stage, run, check = function() TRUE, prepare = function() {}) {
  stage$add_task(run, check, prepare)
}
