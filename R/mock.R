#' @include ci.R
MockCI <- R6Class(
  "MockCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      "mock-ci-branch"
    }
  )
)
