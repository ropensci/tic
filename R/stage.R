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

    get_steps = function() {
      private$steps
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
