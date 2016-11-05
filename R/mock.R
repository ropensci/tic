MockCI <- R6Class(
  "TravisCI",
  inherits = CI,

  public = list(
    get_branch = function() {
      "mock-ci-branch"
    }
  )
)
