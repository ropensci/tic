# nocov start
#' @include ci.R
AppVeyorCI <- R6Class( # nolint
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
      paste0(
        "https://ci.appveyor.com/project/", self$get_slug(), "/build/",
        self$get_env("APPVEYOR_BUILD_VERSION")
      )
    },
    get_commit = function() {
      Sys.getenv("TRAVIS_COMMIT")
    },
    can_push = function(name = "TRAVIS_DEPLOY_KEY") {
      # id_rsa is the "old" name which was previously hard coded in the {travis}
      # package. New default name: "TRAVIS_DEPLOY_KEY"
      # for backward comp we check for the old one too
      can_push <- self$has_env(name)
      if (!can_push) {
        cli_alert_danger("Deployment was requested but the build is not able to
                         deploy. We checked for env var {.var {name}} but could
                         not find as an env var in Travis CI.
                         Double-check if it exists. Calling
                         {.fun travis::use_travis_deploy} may help resolving
                         issues.", wrap = TRUE)
        stopc("This build cannot deploy to Github.")
      }
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
