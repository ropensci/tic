# nocov start
#' @include ci.R
TravisCI <- R6Class(
  "TravisCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("TRAVIS_BRANCH")
    },
    get_slug = function() {
      Sys.getenv("TRAVIS_REPO_SLUG")
    },
    get_build_number = function() {
      Sys.getenv("TRAVIS_BUILD_NUMBER")
    },
    get_build_url = function() {
      paste0("https://travis-ci.org/", self$get_slug(), "/builds/", Sys.getenv("TRAVIS_BUILD_ID"))
    },
    get_commit = function() {
      Sys.getenv("TRAVIS_COMMIT")
    }
  )
)
# nocov end
