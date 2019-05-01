#' @include ci.R
MockCI <- R6Class(
  "MockCI",
  inherit = CI,

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
    can_push = function(name = "id_rsa") {
      self$has_env(name)
    },
    get_env = function(env) {
      Sys.getenv(env)
    },
    is_env = function(env, value) {
      self$get_env(env) == value
    },
    has_env = function(env) {
      self$get_env(env) != ""
    },
    is_interactive = function() {
      TRUE
    }
  )
)
