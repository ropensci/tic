# nocov start
#' @include ci.R
AppVeyorCI <- R6Class(
  "AppVeyorCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      Sys.getenv("APPVEYOR_REPO_BRANCH")
    }
  )
)
# nocov end
