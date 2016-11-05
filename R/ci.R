CI <- R6Class(
  "CI",

  public = list(
    branch = function() {
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
