TicStage <- R6Class( # nolint
  "TicStage",
  public = list(
    initialize = function(name) {
      private$name <- name
      private$steps <- list()
    },

    add_step = function(step, code) {
      self$add_task(
        run = step$run, check = step$check, prepare = step$prepare,
        name = code
      )
    },

    add_task = function(run, check = NULL, prepare = NULL, name = NULL) {
      step <- list(
        run = run,
        check = check %||% function() TRUE,
        prepare = prepare %||% function() {}, # nolint
        name = name %||% "<unknown task>"
      )
      private$steps <- c(private$steps, list(step))
      invisible(self)
    },

    is_empty = function() {
      is_empty(private$steps)
    },

    reset = function() {
      private$steps <- list()
    },

    prepare_all = function() {

      # check if DESCRIPTION file exists
      path <- paste0(usethis::proj_get(), "/DESCRIPTION")
      if (!file_exists(path)) {
        cli::cli_alert_danger("{.pkg tic} requires a DESCRIPTION file for
        installing dependencies, please add one.", wrap = TRUE)
        stop("Can't find DESCRIPTION.",
          call. = FALSE
        )
      }

      # check if package name is valid
      check_package_name()

      lapply(private$steps, private$prepare_one)
      invisible()
    },

    run_all = function() {
      success <- TRUE
      for (step in private$steps) {
        if (!private$run_one(step)) {
          stopc(
            'A step failed in stage "', private$name, '": ', private$name, "."
          )
        }
      }
    },

    print = function(..., omit_if_empty = FALSE) {
      if (omit_if_empty && length(private$steps) == 0) {
        return()
      }
      cat_rule(private$name, right = "stage", col = "green")

      if (length(private$steps) == 0) {
        cat_bullet("No steps defined", bullet = "info")
      } else {
        lapply(private$steps, function(x) cat_bullet(x$name, bullet = "play"))
      }
    }
  ),

  private = list(
    name = NULL,
    steps = NULL,

    prepare_one = function(step) {
      if (identical(body(step$prepare), body(TicStep$public_methods$prepare))) {
        return()
      }

      if (!isTRUE(step$check())) {
        ci_cat_with_color(
          crayon::magenta(paste0("Skipping prepare: ", step$name))
        )
        print(step$check)
        return()
      }

      ci_cat_with_color(
        crayon::magenta(paste0("Preparing: ", step$name))
      )
      step$prepare()

      invisible()
    },

    run_one = function(step) {
      if (!isTRUE(step$check())) {
        ci_cat_with_color(
          crayon::magenta(paste0("Skipping ", private$name, ": ", step$name))
        )
        print(step$check)
        return(TRUE)
      }

      ci_cat_with_color(
        crayon::magenta(paste0("Running ", private$name, ": ", step$name))
      )

      top <- environment()

      tryCatch(
        { # nolint
          with_abort({
            step$run()
            TRUE
          })
        },
        error = function(e) {
          ci_cat_with_color(format(e))
          FALSE
        }
      )
    }
  )
)

new_stages <- function(x) {
  structure(x, class = "TicStages")
}

stage_is_empty <- function(x) {
  x$is_empty()
}
