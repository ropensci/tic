#' @importFrom R6 R6Class
#' @export
TravisTask <- R6Class(
  "TravisTask",
  cloneable = FALSE,

  public = list(
    initialize = function(on_branch = NULL) {
      private$on_branch = on_branch

    },
    run = function() {
      stop("Please override the run() method to do something useful.", call. = FALSE)
    },
    prepare = function() {},
    check = eval(bquote(function() {
      private$match_branch(ci()$get_branch())
    }))
  ),

  private = list(
    on_branch = NULL,

    match_branch = function(branch) {
      match_regex <- "^/(.*)/$"
      if (is.null(private$on_branch)) {
        TRUE
      } else if (length(private$on_branch) == 1 && grepl(match_regex, private$on_branch)) {
        grepl(gsub(match_regex, "\\1", private$on_branch), branch)
      } else {
        any(private$on_branch %in% branch)
      }
    }
  )
)

HelloWorld <- R6Class(
  "HelloWorld", inherit = TravisTask,

  public = list(
    run = function() {
      print("Hello, world!")
    }
  )
)

#' @export
task_hello_world <- HelloWorld$new
