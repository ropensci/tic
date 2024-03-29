TicStage <- R6Class( # nolint
  "TicStage",
  public = list(
    initialize = function(stage_name) {
      private$stage_name <- stage_name
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
      existing_steps <- vapply(private$steps, function(.x) .x$name,
        FUN.VALUE = character(1)
      )
      if (name %in% existing_steps) {
        invisible(self)
      } else {
        private$steps <- c(private$steps, list(step))
        invisible(self)
      }
    },
    is_empty = function() {
      is_empty(private$steps)
    },
    reset = function() {
      private$steps <- list()
    },
    prepare_all = function() {
      # We don't necessarily require a DESCRIPTION file.
      # Steps that need one can check beforehand and warn the user with a
      # legible message.
      lapply(private$steps, private$prepare_one)
      invisible()
    },
    run_all = function() {
      success <- TRUE
      for (step in private$steps) {
        if (!private$run_one(step)) {
          stopc(
            'A step failed in stage "', private$stage_name, '": ',
            private$stage_name, "."
          )
        }
      }
    },
    print = function(..., omit_if_empty = FALSE) {
      if (omit_if_empty && length(private$steps) == 0) {
        return()
      }
      cli::cat_rule(sprintf("Stage: %s", private$stage_name), line_col = "yellow", col = "blue")

      if (length(private$steps) == 0) {
        cat_bullet("No steps defined", bullet = "info")
      } else {
        names <- sapply(private$steps, function(x) x$name)
        cli::cat_bullet(gsub(
          ",", ", ",
          gsub(" ", "", gsub("\n", "", names))
        ), bullet = "play", bullet_col = "yellow", col = "blue")
      }
    }
  ),
  private = list(
    stage_name = NULL,
    steps = NULL,
    prepare_one = function(step) {
      if (identical(body(step$prepare), body(TicStep$public_methods$prepare))) {
        return()
      }

      if (!isTRUE(step$check())) {
        cli::cat_bullet(
          paste0("Skipping prepare: ", step$stage_name),
          bullet = "info",
          col = "magenta"
        )
        print(step$check)
        return()
      }

      cli::cat_bullet(
        paste0("Preparing stage '", private$stage_name, "': ", gsub(
          ",", ", ",
          gsub(" ", "", gsub(
            "\n", "", cli::col_silver(step$name)
          ))
        )),
        bullet = "info",
        col = "magenta"
      )
      step$prepare()

      cli::cat_bullet(
        paste0("Finished preparing: ", gsub(
          ",", ", ",
          gsub(" ", "", gsub(
            "\n", "", cli::col_silver(step$name)
          ))
        )),
        bullet = "tick",
        col = "magenta"
      )

      invisible()
    },
    run_one = function(step) {
      if (!isTRUE(step$check())) {
        cli::cat_bullet(
          paste0(
            "Skipping ", private$stage_name, ": ",
            step$stage_name
          ),
          bullet = "info",
          col = "magenta"
        )
        print(step$check)
        return(TRUE)
      }

      cli::cat_bullet(paste0("Running stage '", private$stage_name, "': ", gsub(
        ",", ", ",
        gsub(" ", "", gsub(
          "\n", "",
          cli::col_silver(step$name)
        ))
      )),
      bullet = "info", col = "cyan"
      )

      top <- environment()

      tryCatch(
        { # nolint
          with_entraced_errors({
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

#' @importFrom rlang try_fetch
# rlang::with_abort() replacement since rlang 1.0.0
# https://github.com/r-lib/rlang/issues/1351
with_entraced_errors <- function(expr) {
  try_fetch(
    expr,
    simpleError = function(cnd) {
      abort(
        conditionMessage(cnd),
        call = conditionCall(cnd)
      )
    }
  )
}
