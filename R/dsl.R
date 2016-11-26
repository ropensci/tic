load_from_file_ <- function(path = "tic.R") {
  dsl <- create_dsl(envir = asNamespace(packageName()))
  source(path, local = dsl)
  dsl$get_stages()
}

#' @export
load_from_file <- memoise::memoise(load_from_file_)

#' @importFrom magrittr %>%
TicDSL <- R6Class(
  "TicDSL",

  public = list(
    initialize = function() {
      private$stages <- as.environment(
        list(
          after_success = Stage$new("after_success"),
          deploy = Stage$new("deploy")
        )
      )
    },

    get_stage = function(name) {
      get(name, private$stages)
    },

    get_stages = function() {
      as.list(private$stages)
    },

    add_step = function(stage, step) {
      stage$add_step(step)
    },

    add_task = function(stage, run, check = NULL, prepare = NULL) {
      stage$add_task(run, check, prepare)
    }
  ),

  private = list(
    stages = NULL
  )
)

create_dsl <- function(envir = parent.frame()) {
  dsl <- TicDSL$new()
  parent.env(dsl) <- envir
  dsl
}
