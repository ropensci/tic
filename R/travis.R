TravisCI <- R6Class(
  "TravisCI",
  inherits = CI,

  public = list(
    branch = function() {
      Sys.getenv("TRAVIS_BRANCH")
    }
  )
)
