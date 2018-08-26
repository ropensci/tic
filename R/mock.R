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
    get_slug = function() {
      "user/repo"
    },
    get_build_number = function() {
      "mock build"
    },
    get_build_url = function() {
      "http://build.url"
    },
    get_commit = function() {
      "00000000000000000000000000000000"
    },
    is_interactive = function() {
      TRUE
    }
  )
)
