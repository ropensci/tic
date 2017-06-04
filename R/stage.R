Stage <- R6Class(
  "Stage",

  public = list(
    initialize = function(name) {
      private$name <- name
    },

    add_step = function(step) {
      self$add_task(run = step$run, check = step$check, prepare = step$prepare,
                    name = class(step)[[1]])
    },

    add_task = function(run, check = NULL, prepare = NULL, name = NULL) {
      step <- list(
        run = run,
        check = check %||% function() TRUE,
        prepare = prepare %||% function() {},
        name = name %||% "<unknown task>"
      )
      private$steps <- c(private$steps, list(step))
      invisible(self)
    },

    reset = function() {
      private$steps <- list()
    },

    prepare_all = function() {
      lapply(private$steps, private$prepare_one)
    },

    run_all = function() {
      lapply(private$steps, private$run_one)
    }
  ),

  private = list(
    name = NULL,
    steps = list(),

    prepare_one = function(step) {
      if (identical(body(step$prepare), body(TicStep$public_methods$prepare)))
        return()

      if (!isTRUE(step$check())) {
        message("Skipping prepare: ", step$name)
        print(step$check)
        return()
      }

      message("Preparing: ", step$name)
      step$prepare()

      invisible()
    },

    run_one = function(step) {
      if (!isTRUE(step$check())) {
        message("Skipping ", private$name, ": ", step$name)
        print(step$check)
        return()
      }

      cat_line(crayon::inverse("Running ", private$name, ": ", step$name))
      step$run()
    }
  )
)
