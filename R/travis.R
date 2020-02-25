# nocov start
#' @include ci.R
TravisCI <- R6Class(
  "TravisCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("TRAVIS_BRANCH")
    },
    get_tag = function() {
      Sys.getenv("TRAVIS_TAG")
    },
    is_tag = function() {
      self$get_tag() != ""
    },
    get_slug = function() {
      Sys.getenv("TRAVIS_REPO_SLUG")
    },
    get_build_number = function() {
      paste0("Travis build ", self$get_env("TRAVIS_BUILD_NUMBER"))
    },
    get_build_url = function() {
      paste0(
        self$get_env("TRAVIS_BUILD_WEB_URL")
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
    cat_with_color = function(code) {
      withr::with_options(
        list(crayon.enabled = TRUE),
        cat_line(code)
      )
    },
    on_travis = function() {
      TRUE
    }
  )
)
# nocov end
