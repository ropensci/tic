# nocov start
#' @include ci.R
DRONE_CI <- R6Class( # nolint
  "DRONE_CI",
  inherit = CI,
  public = list(
    get_branch = function() {
      Sys.getenv("DRONE_BRANCH")
    },
    get_tag = function() {
      Sys.getenv("DRONE_TAG")
    },
    is_tag = function() {
      self$get_tag() != ""
    },
    get_slug = function() {
      Sys.getenv("DRONE_REPO")
    },
    get_build_number = function() {
      paste0("DRONE_CI build ", self$get_env("DRONE_BUILD_NUMBER"))
    },
    get_build_url = function() {
      Sys.getenv("DRONE_BUILD_LINK")
    },
    get_commit = function() {
      Sys.getenv("DRONE_COMMIT")
    },
    can_push = function(name) {
      # Deployment permissions must be ensured by users themselves on their
      # environment.
      # Setting TRUE to proceed anyway and error during git push in
      # `step_do_push_deploy()`.
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
    ON_DRONE = function() {
      TRUE
    }
  )
)
# nocov end
