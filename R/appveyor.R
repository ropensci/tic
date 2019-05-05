# nocov start
#' @include ci.R
AppVeyorCI <- R6Class(
  "AppVeyorCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("APPVEYOR_REPO_BRANCH")
    },
    get_tag = function() {
      Sys.getenv("APPVEYOR_REPO_TAG")
    },
    is_tag = function() {
      self$get_tag() != ""
    },
    get_slug = function() {
      Sys.getenv("APPVEYOR_REPO_NAME")
    },
    get_build_number = function() {
      paste0("AppVeyor build ", self$get_env("APPVEYOR_BUILD_NUMBER"))
    },
    get_build_url = function() {
      paste0("https://ci.appveyor.com/project/", self$get_slug(), "/build/", self$get_env("APPVEYOR_BUILD_VERSION"))
    },
    get_commit = function() {
      Sys.getenv("TRAVIS_COMMIT")
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
    on_appveyor = function() {
      TRUE
    }
  )
)
# nocov end
