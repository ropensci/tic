#' @importFrom R6 R6Class
#' @export
TravisTask <- R6Class(
  "TravisTask",
  cloneable = FALSE,

  public = list(
    initialize = function(on_branch = NULL) {
      private$on_branch = on_branch

    },
    run = function() {},
    prepare = function() {},
    check = eval(bquote(function() {
      private$match_branch(Sys.getenv("TRAVIS_BRANCH"))
    }))
  ),

  private = list(
    on_branch = NULL,

    match_branch = function(branch) {
      match_regex <- "^/(.*)/$"
      if (is.null(private$on_branch)) {
        TRUE
      } else if (grepl(match_regex, private$on_branch)) {
        grepl(gsub(match_regex, "\\1", private$on_branch), branch)
      } else {
        branch %in% private$on_branch
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
