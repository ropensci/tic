MockCI <- R6Class(
  "TravisCI",
  inherits = CI,

  public = list(
    branch = function() {
      "mock-ci-branch"
    }
  )
)
