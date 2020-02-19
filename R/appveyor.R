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
      self$get_tag() == "true"
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
    can_push = function(private_key_name = "TIC_DEPLOY_KEY") {
      # id_rsa is the "old" name which was previously hard coded in the {travis}
      # package. New default name: "TIC_DEPLOY_KEY"
      # for backward comp we check for the old one too
      private_key_name <- compat_ssh_key(private_key_name)
      self$has_env(private_key_name)
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
