LocalCI <- R6Class(
  "LocalCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      system2("git", "rev-parse --abbrev-ref HEAD", stdout = TRUE)
    },
    get_slug = function() {
      remote <- gh::gh_tree_remote()
      paste0(remote$username, "/", remote$repo)
    },
    get_build_number = function() {
      "local build"
    },
    get_build_url = function() {
      NULL
    },
    get_commit = function() {
      system2("git", "rev-parse HEAD", stdout = TRUE)
    },
    is_interactive = function() {
      TRUE
    }
  )
)
