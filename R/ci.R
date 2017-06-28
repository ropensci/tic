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

#' The current CI environment
#'
#' Returns an instance of the CI class that describes the CI environment.
#' The value is retrieved only once and then cached.
#'
#' @export
ci <- memoise::memoise(ci_)

#' @rdname ci
CI <- R6Class(
  "CI",

  public = list(
    #' @section Methods:
    #' \describe{
    #'   \item{`get_branch()`}{The current branch name, empty if tag.}
    get_branch = function() {
      stop("NYI")
    },
    #'   \item{`get_tag()`}{The current tag name, empty if branch.}
    get_tag = function() {
      stop("NYI")
    },
    #'   \item{`is_tag()`}{Branch or tag?}
    is_tag = function() {
      stop("NYI")
    },
    #'   \item{`get_slug()`}{The repo slug in the format `user/repo` or `org/repo`.}
    get_slug = function() {
      stop("NYI")
    },
    #'   \item{`get_build_number()`}{The build number.}
    get_build_number = function() {
      stop("NYI")
    },
    #'   \item{`get_build_url()`}{The URL of the build.}
    get_build_url = function() {
      stop("NYI")
    },
    #'   \item{`get_commit()`}{The SHA1 of the current commit.}
    get_commit = function() {
      stop("NYI")
    },
    #'   \item{`is_interactive()`}{
    #'     Global setup operations shouldn't be run on an interactive CI,
    #'     only on unattended CIs where this method returns `FALSE`.}
    is_interactive = function() {
      FALSE
    },

    #'   \item{`cat_with_color(text)`}{
    #'     Colored output targeted to the CI log.
    #'     The `text` argument can be a call to a \pkg{crayon} function,
    #'     the style will be applied even if it normally wouldn't be.
    #'   }
    cat_with_color = function(text) {
      cat_line(text)
    }

    #' }
  )
)
