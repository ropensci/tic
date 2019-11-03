# nocov start
#' @include ci.R
CircleCI <- R6Class(
  "CircleCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("CIRCLE_BRANCH")
    },
    get_tag = function() {
      Sys.getenv("CIRCLE_TAG")
    },
    is_tag = function() {
      self$get_tag() != ""
    },
    get_slug = function() {
      sprintf("%s/%s", Sys.getenv("CIRCLE_PROJECT_USERNAME"), Sys.getenv("CIRCLE_PROJECT_REPONAME"))
    },
    get_build_number = function() {
      paste0("CircleCI build ", self$get_env("CIRCLE_BUILD_NUM"))
    },
    get_build_url = function() {
      Sys.getenv("CIRCLE_BUILD_URL")
    },
    get_commit = function() {
      Sys.getenv("TRAVIS_COMMIT")
    },
    can_push = function(name) {
      # FIXME: Currently there is no way to check for the 'github-user-key' on
      # Circle CI in an easy way (we always need the API key).
      # Proceed anyway and error during git push in `step_do_push_deploy()`.
      TRUE
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
    on_circle = function() {
      TRUE
    }
  )
)
# nocov end
