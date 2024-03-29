ci_ <- function() {
  if (Sys.getenv("TIC_LOCAL") == "true") {
    LocalCI$new()
  } else if (Sys.getenv("TIC_MOCK") == "true") {
    MockCI$new()
  } else if (Sys.getenv("CIRCLECI") == "true") {
    CircleCI$new()
  } else if (Sys.getenv("GITHUB_ACTIONS") == "true") {
    GHActionsCI$new()
  } else if (Sys.getenv("DRONE_CI") == "true") {
    DRONE_CI$new()
  } else {
    LocalCI$new()
  }
}

CI <- R6Class( # nolint
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
    #'   \item{`get_env()`}{The value of the env variable}
    get_env = function(env) {
      stop("NYI")
    },
    #'  \item{`is_env()`}{Is the given env variable set to the given value?}

    is_env = function(env, value) {
      stop("NYI")
    },
    #'   \item{`has_env()`}{Does the given env variable exist?}
    has_env = function(env) {
      stop("NYI")
    },
    #'   \item{`get_slug()`}{
    #'     The repo slug in the format `user/repo` or `org/repo`.}
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
    #'   \item{`get_commit()`}{Does an env variable named `"TIC_DEPLOY_KEY"`
    #'   exist?}
    can_push = function() {
      stop("NYI")
    },
    #'   \item{`on_circle()`}{
    #'     Returns `TRUE` only on circle, otherwise `FALSE`.}
    on_circle = function() {
      FALSE
    },
    #'   \item{`on_ghactions()`}{
    #'     Returns `TRUE` only on GitHub Actions, otherwise `FALSE`.}
    on_ghactions = function() {
      FALSE
    },
    #'   \item{`is_interactive()`}{
    #'     Global setup operations shouldn't be run on an interactive CI,
    #'     only on unattended CIs where this method returns `FALSE`.}
    is_interactive = function() {
      FALSE
    },

    #'   \item{`cat_with_color(code)`}{
    #'     Colored output targeted to the CI log.
    #'     The `code` argument can be an unevaluated call to a
    #'     \pkg{crayon} function,
    #'     the style will be applied even if it normally wouldn't be.
    #'   }
    cat_with_color = function(code) {
      cat_line(code)
    }

    #' }
  )
)

#' The current CI environment
#'
#' @description Functions that return environment settings that describe the CI
#'   environment. The value is retrieved only once and then cached.
#'
#'   `ci_get_branch()`: Returns the current branch. Returns nothing if operating
#'   on a tag.
#' @name ci
#' @export
ci_get_branch <- function() {
  ci()$get_branch()
}

#' CI tag
#'
#' `ci_is_tag()`: Returns the current tag name. Returns nothing if a branch is
#' selected.
#' @rdname ci
#' @export
ci_is_tag <- function() {
  ci()$is_tag()
}

#' CI slug
#'
#' `ci_get_slug()`: Returns the repo slug in the format `user/repo` or
#' `org/repo`
#' @rdname ci
#' @export
ci_get_slug <- function() {
  ci()$get_slug()
}

#' CI build number
#'
#' `ci_get_build_number()`: Returns the CI build number.
#' @rdname ci
#' @export
ci_get_build_number <- function() {
  ci()$get_build_number()
}

#' CI build URL
#'
#' `ci_get_build_url()`: Returns the URL of the current build.
#' @rdname ci
#' @export
ci_get_build_url <- function() {
  ci()$get_build_url()
}

#' CI commit
#'
#' `ci_get_commit()`: Returns the SHA1 of the current commit.
#' @rdname ci
#' @export
ci_get_commit <- function() {
  ci()$get_commit()
}

#' CI get env
#'
#' `ci_get_env()`: Return an environment or configuration variable.
#' @rdname ci
#' @export
ci_get_env <- function(env) {
  ci()$get_env(env)
}

#' CI is env
#'
#' `ci_is_env()`: Checks if an environment or configuration variable is set to a
#' particular value.
#' @rdname ci
#' @param env Name of the environment variable to check.
#' @param value Value for the environment variable to compare against.
#' @export
ci_is_env <- function(env, value) {
  ci()$is_env(env, value)
}

#' CI has env
#'
#' `ci_has_env()`: Checks if an environment or configuration variable is set to
#' any value.
#' @rdname ci
#' @export
ci_has_env <- function(env) {
  ci()$has_env(env)
}

#' CI can push
#'
#' `ci_can_push()`: Checks if push deployment is possible. Always true
#'   for local environments, CI environments require an environment
#'   variable (by default `TIC_DEPLOY_KEY`).
#' @rdname ci
#' @template private_key_name
#' @export
ci_can_push <- function(private_key_name = "TIC_DEPLOY_KEY") {
  ci()$can_push(private_key_name)
}

#' CI is_interactive
#'
#' `ci_is_interactive()`: Returns whether the current build is run interactively
#' or not. Global setup operations shouldn't be run on interactive CIs.
#' @rdname ci
#' @export
ci_is_interactive <- function() {
  ci()$is_interactive()
}

#' CI cat with color
#' @description `ci_cat_with_color()`: Colored output targeted to the CI log.
#'   The code argument can be an unevaluated call to a crayon function, the
#'   style will be applied even if it normally wouldn't be.
#' @param code Code that should be colored.
#' @rdname ci
#' @export
ci_cat_with_color <- function(code) {
  ci()$cat_with_color(code)
}

#' CI on_circle
#' @description `ci_on_circle()`: Are we running on Circle CI?
#' @rdname ci
#' @export
ci_on_circle <- function() {
  ci()$on_circle()
}

#' CI on_ghactions
#' @description `ci_on_ghactions()`: Are we running on GitHub Actions?
#' @rdname ci
#' @export
ci_on_ghactions <- function() {
  ci()$on_ghactions()
}

#' The current CI environment
#'
#' `ci()`: Return the current CI environment
#'
#' @rdname ci
#' @export
ci <- memoise::memoise(ci_)
