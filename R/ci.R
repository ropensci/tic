CI <- R6Class(
  "CI",

  public = list(
    get_branch = function() {
      stop("NYI")
    },
    get_tag = function() {
      stop("NYI")
    },
    is_tag = function() {
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
    },
    is_interactive = function() {
      FALSE
    },

    cat_with_color = function(code) {
      cat_line(code)
    }
  )
)

ci_ <- function() {
  if (Sys.getenv("TIC_MOCK") == "true") {
    MockCI$new()
  } else if (Sys.getenv("TRAVIS") == "true") {
    TravisCI$new()
  } else if (Sys.getenv("APPVEYOR") == "True") {
    AppVeyorCI$new()
  } else {
    LocalCI$new()
  }
}

#' @export
ci <- memoise::memoise(ci_)
