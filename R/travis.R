# nocov start
#' @include ci.R
TravisCI <- R6Class(
  "TravisCI", inherit = CI,

  public = list(
    get_branch = function() {
      self$has_env("TRAVIS_BRANCH")
    },
    get_tag = function() {
      self$has_env("TRAVIS_TAG")
    },
    is_tag = function() {
      self$get_tag() != ""
    },
    get_slug = function() {
      self$has_env("TRAVIS_REPO_SLUG")
    },
    get_build_number = function() {
      paste0("Travis build ", self$has_env("TRAVIS_BUILD_NUMBER"))
    },
    get_build_url = function() {
      paste0("https://travis-ci.org/", self$get_slug(), "/builds/", self$has_env("TRAVIS_BUILD_ID"))
    },
    get_commit = function() {
      self$has_env("TRAVIS_COMMIT")
    },
    can_push = function() {
      self$has_env("id_rsa")
    },
    is_env = function(env, value) {
      self$is_env(env, value)
    },
    has_env = function(env) {
      self$has_env(env)
    },
    cat_with_color = function(code) {
      withr::with_options(
        list(crayon.enabled = TRUE),
        cat_line(code)
      )
    }
  )
)
# nocov end
