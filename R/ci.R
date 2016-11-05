CI <- R6Class(
  "CI",

  public = list(
    get_branch = function() {
      stop("NYI")
    },
    get_slug = function() {
      stop("NYI")
    },
    get_build_number = function() {
      stop("NYI")
    },
    get_build_url = function() {
      stop("NYI")
    },
    get_commit = function() {
      stop("NYI")
    }
  )
)

ci_ <- function() {
  if (Sys.getenv("TRAVIS") == "true") {
    TravisCI$new()
  } else if (Sys.getenv("APPVEYOR") == "True") {
    AppVeyorCI$new()
  } else if (Sys.getenv("CI") != "") {
    stopc("Unknown CI system")
  } else {
    MockCI$new()
  }
}

ci <- memoise::memoise(ci_)
