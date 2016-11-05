TravisCI <- R6Class(
  "TravisCI",
  inherits = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("TRAVIS_BRANCH")
    }
  )
)
