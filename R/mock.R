#' @include ci.R
MockCI <- R6Class(
  "MockCI", inherit = CI,

  public = list(
    get_branch = function() {
      "mock-ci-branch"
    },
    get_tag = function() {
      "mock-ci-tag"
    },
    is_tag = function() {
      FALSE
    },
    is_interactive = function() {
      TRUE
    }
  )
)
