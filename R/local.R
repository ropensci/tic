LocalCI <- R6Class(
  "LocalCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      suppressWarnings(system2("git", "rev-parse --abbrev-ref HEAD", stdout = TRUE))
    },
    get_tag = function() {
      suppressWarnings(system2("git", "describe", stdout = TRUE))
    },
    is_tag = function() {
      suppressWarnings(length(system2("git", c("tag", "--points-at", "HEAD"), stdout = TRUE)) > 0)
    },
    get_slug = function() {
      tryCatch(
        {
          remote <- gh::gh_tree_remote()
          paste0(remote$username, "/", remote$repo)
        },
        error = ""
      )
    },
    get_build_number = function() {
      "local build"
    },
    get_build_url = function() {
      NULL
    },
    get_commit = function() {
      tryCatch(git2r::revparse_single(revision = "HEAD")$sha, error = "")
    },
    can_push = function(name = "TRAVIS_DEPLOY_KEY") {
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
    is_interactive = function() {
      TRUE
    }
  )
)
