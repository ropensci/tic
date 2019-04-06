# nocov start
#' @include ci.R
AppVeyorCI <- R6Class(
  "AppVeyorCI", inherit = CI,

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
      paste0("AppVeyor build ", Sys.getenv("APPVEYOR_BUILD_NUMBER"))
    },
    get_build_url = function() {
      paste0("https://ci.appveyor.com/project/", self$get_slug(), "/build/", Sys.getenv("APPVEYOR_BUILD_VERSION"))
    },
    get_commit = function() {
      Sys.getenv("TRAVIS_COMMIT")
    },
    can_push = function() {
      Sys.getenv("id_rsa") != ""
    }
  )
)
# nocov end
