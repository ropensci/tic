# nocov start
#' @include ci.R
GHActionsCI <- R6Class( # nolint
  "GHActionsCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      ref = Sys.getenv("GITHUB_REF")
      # hopefully this also works for tags
      branch = strsplit(ref, "/", )[[1]][3]
    },
    get_tag = function() {
      # FIXME: No way to get a tag? Merged with env var GITHUB_REF
      # https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
      return("")
    },
    is_tag = function() {
      self$get_tag() == "true"
    },
    get_slug = function() {
      Sys.getenv("GITHUB_REPOSITORY")
    },
    get_build_number = function() {
      # FIXME: Don't know how to get the build number in the url
      return("")
    },
    get_build_url = function() {
      # FIXME: Needs build number
      return("")
    },
    get_commit = function() {
      Sys.getenv("GITHUB_SHA")
    },
    can_push = function(name) {
      # if (Sys.getenv("GITHUB_TOKEN") != "") {
      #   return(TRUE)
      # } else {
      #   return(FALSE)
      # }
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
    on_ghactions = function() {
      TRUE
    }
  )
)
# nocov end
