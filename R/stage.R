Stage <- R6Class(
  "Stage",

  public = list(
    initialize = function(name) {
      private$name <- name
      private$steps <- list()
    },

    add_step = function(step, code) {
      self$add_task(run = step$run, check = step$check, prepare = step$prepare,
                    name = code)
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
      invisible()
    },

    run_all = function() {
      success <- vlapply(private$steps, private$run_one)
      if (!all(success)) {
        stopc("At least one step failed.")
      }
    }
  ),

  private = list(
    name = NULL,
    steps = NULL,

    prepare_one = function(step) {
      if (identical(body(step$prepare), body(TicStep$public_methods$prepare)))
        return()

      if (!isTRUE(step$check())) {
        ci()$cat_with_color(
          crayon::magenta(paste0("Skipping prepare: ", step$name))
        )
        print(step$check)
        return()
      }

      ci()$cat_with_color(
        crayon::magenta(paste0("Preparing: ", step$name))
      )
      step$prepare()

      invisible()
    },

    run_one = function(step) {
      if (!isTRUE(step$check())) {
        ci()$cat_with_color(
          crayon::magenta(paste0("Skipping ", private$name, ": ", step$name))
        )
        print(step$check)
        return(TRUE)
      }

      ci()$cat_with_color(
        crayon::magenta(paste0("Running ", private$name, ": ", step$name))
      )

      tryCatch(
        {
          step$run()
          TRUE
        },
        error = function(e) {
          ci()$cat_with_color(crayon::red(paste0("Error: ", conditionMessage(e))))
          FALSE
        }
      )
    }
  )
)
