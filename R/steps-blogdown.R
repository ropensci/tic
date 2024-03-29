BuildBlogdown <- R6Class(
  "BuildBlogdown",
  inherit = TicStep,

  public = list(
    initialize = function(...) {
      private$blogdown_args <- list(...)
      super$initialize()
    },

    run = function() {
      do.call(blogdown::build_site, private$blogdown_args)
    },

    prepare = function() {
      verify_install(c("blogdown"))
      super$prepare()
    }
  ),

  private = list(
    blogdown_args = NULL
  )
)

#' Step: Build a Blogdown Site
#'
#' Build a Blogdown site using [blogdown::build_site()].
#'
#' @inheritDotParams blogdown::build_site
#'
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_build_blogdown("."))
#'
#' dsl_get()
step_build_blogdown <- function(...) {
  BuildBlogdown$new(...)
}
