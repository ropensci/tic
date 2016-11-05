#' @include ci.R
MockCI <- R6Class(
  "TravisCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      "mock-ci-branch"
    }
  )
)
