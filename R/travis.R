#' @include ci.R
TravisCI <- R6Class(
  "TravisCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("TRAVIS_BRANCH")
    }
  )
)
