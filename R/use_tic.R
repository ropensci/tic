#' @title Initialize CI testing using tic
#' @description Prepares a repo for building and deploying supported by
#' \pkg{tic}.
#'
#' @importFrom utils menu
#' @details
#'
#' 1. Query information which CI providers should be used
#' 1. Setup permissions for providers selected for deployment
#' 1. Create YAML files for selected providers
#' 1. Create a default `tic.R` file depending on the repo type
#'    (package, website, bookdown, ...)
#'
#' @param wizard `[flag]`\cr Interactive operation? If `TRUE`,
#'   a menu will be shown.
#' @param linux,windows,mac `[string]`\cr Which CI provider(s) to use to test on
#'   Linux, Windows, and macOS, respectively.
#' @param deploy `[string]`\cr Which CI provider(s) to use to
#'   deploy artifacts such as pkgdown documentation.
#' @param matrix `[string]`\cr For which CI provider(s) to set up
#'   matrix builds.
#' @param quiet `[flag]`\cr Less verbose output? Default: `FALSE`.
#' @export
#' @examples
#' # Requires interactive mode
#' if (FALSE) {
#'   use_tic()
#'
#'   # Pre-specified settings favoring Circle CI:
#'   use_tic(
#'     linux = "circle",
#'     mac = "travis",
#'     windows = "appveyor",
#'     deploy = "circle",
#'     matrix = "all"
#'   )
#' }
use_tic <- function(wizard = interactive(),
                    linux = c("travis", "circle", "none", "all"),
                    mac = c("none", "travis", "all"),
                    windows = c("none", "appveyor", "all"),
                    deploy = c("travis", "circle", "none", "all"),
                    matrix = c("none", "travis", "circle", "appveyor", "all"),
                    quiet = FALSE) { # nolint
  cli_alert("Welcome to {.pkg tic}!")
  cli_text(
    "This wizard will guide you through the setup process for getting started
    with various CI providers."
  )

  cli_h1("Introduction:")
  cli_text("{.pkg tic} currently comes with support for three CI providers: ")

  cli_ul(c("Appveyor", "Circle CI", "Travis CI"))

  cli_par()
  cli_text(c(
    "There is no need to use all of them.",
    " You can choose which one(s) you want to use,",
    " whether you want to deploy (i.e. push from builds)",
    " and if you want to test on multiple R versions."
  ))
  cli_end()

  cli_text("We recommend the following setup:")
  cli_ul(c("Travis CI: Linux", "Travis CI: macOS", "Appveyor: Windows"))
  cli_par()
  cli_end()

  if (wizard) {
    if (yesno("Ready to get started?")) {
      return(invisible(NULL))
    }

    cli_h1("Choosing your setup.")
    cli_text("We'll ask you a few yes/no questions to gather your preferences.")
    cli_par()
    cli_end()

    linux <- ci_menu(linux,
      title = "Which provider do you want to use for Linux builds?"
    )

    mac <- ci_menu(mac,
      title = "Do you want to build on macOS (= Travis CI)?"
    )

    windows <- ci_menu(windows,
      title = "Do you want to build on Windows (= Appveyor)?"
    )

    deploy <- ci_menu(intersect(deploy, c(linux, mac, windows, "all", "none")),
      title = "Do you want to deploy (i.e. push from the CI build to your repo) on certain providers? If yes, which ones?" # nolint
    )

    matrix <- ci_menu(intersect(matrix, c(linux, mac, windows, "all", "none")),
      title = "Do you want to build on multiple R versions? (i.e. R-devel, R-release, R-oldrelease). If yes, on which platform(s)?" # nolint
    )

    wizard <- FALSE
    use_tic_call <- c(
      'tic::use_tic(',
      arg_desc(wizard),
      arg_desc(linux),
      arg_desc(mac),
      arg_desc(windows),
      arg_desc(deploy),
      arg_desc(matrix, last = TRUE),
      ')'
    )
    cli_text("If setup fails, rerun with:")

    # https://github.com/r-lib/cli/issues/127
    withr::with_options(c(cli.width = 30), cli_code(use_tic_call))
  } else {
    linux <- match.arg(linux, several.ok = TRUE)
    mac <- match.arg(mac, several.ok = TRUE)
    windows <- match.arg(windows, several.ok = TRUE)
    deploy <- match.arg(deploy, several.ok = TRUE)
    matrix <- match.arg(matrix, several.ok = TRUE)
  }

  cli_h1("Setting up the CI providers.")

  cli_text(
    "Next we are getting the selected CI providers ready for deployment.",
    " This requires some interaction with their API and you may need to create
    an API token."
  )
  cli_par()
  cli_end()

  # init deploy ----------------------------------------------------------------

  if (circle_in(deploy)) {
    rule(left = "Circle CI")
    check_circle_pkg()
    circle::enable_repo()
    circle::use_circle_deploy()
  } else if (travis_in(deploy)) {
    rule(left = "Travis CI")
    check_travis_pkg()
    travis::travis_enable()
    travis::use_travis_deploy()
  }

  # create YAMLs ---------------------------------------------------------------

  cli_par()
  cli_end()
  cli_h1("Creating YAML files...")

  # Travis ---------------------------------------------------------------------

  rule(left = "Travis CI")

  if (travis_in(linux)) {
    # deployment
    if (travis_in(deploy)) {
      # build matrix
      if (travis_in(matrix)) {
        use_travis_yml("linux-deploy-matrix")
      } else {
        use_travis_yml("linux-deploy")
      }
    } else {
      # build matrix
      if (travis_in(matrix)) {
        use_travis_yml("linux-matrix")
      } else {
        use_travis_yml("linux")
      }
    }
  }

  if (travis_in(mac)) {
    if (travis_in(linux)) {
      stopc("Currently failing, https://github.com/ropenscilabs/tic/issues/202")
    }

    if (travis_in(deploy)) {
      # build matrix
      if (travis_in(matrix)) {
        use_travis_yml("macos-deploy-matrix")
      } else {
        use_travis_yml("macos-deploy")
      }
    } else {
      # build matrix
      if (travis_in(matrix)) {
        use_travis_yml("macos-matrix")
      } else {
        use_travis_yml("macos")
      }
    }
  }

  # Circle ---------------------------------------------------------------------

  rule(left = "Circle CI")

  if (circle_in(linux)) {
    # deployment
    if (circle_in(deploy)) {
      # build matrix
      if (circle_in(matrix)) {
        use_circle_yml("linux-deploy-matrix")
      } else {
        use_circle_yml("linux-deploy")
      }
    } else {
      # build matrix
      if (circle_in(matrix)) {
        use_circle_yml("linux-matrix")
      } else {
        use_circle_yml("linux")
      }
    }
  }

  # Appveyor -------------------------------------------------------------------

  rule(left = "Appveyor CI")

  if (appveyor_in(windows)) {
    if (appveyor_in(matrix)) {
      use_appveyor_yml("windows-matrix")
    } else {
      use_appveyor_yml("windows")
    }
  }

  # tic.R ----------------------------------------------------------------------

  rule(left = "tic")

  use_tic_r(repo_type = detect_repo_type())

  rule("Finished")
  cat_bullet(
    "Done! Thanks for using ", crayon::blue("tic"), ".",
    bullet = "star", bullet_col = "yellow"
  )

  cat_bullet(
    "Below is the file structure of the newly added files (in case you selected
    all providers):",
    bullet = "arrow_down", bullet_col = "blue"
  )

  data <- data.frame(
    stringsAsFactors = FALSE,
    package = c(
      basename(getwd()), ".circleci", "appveyor.yml", ".travis.yml",
      "config.yml", "tic.R"
    ),
    dependencies = I(list(
      c(".circleci", "appveyor.yml", ".travis.yml", "tic.R"),
      "config.yml",
      character(0),
      character(0),
      character(0),
      character(0)
    ))
  )
  tree(data, root = basename(getwd()))

}

arg_desc <- function(arg, last = FALSE) {
  arg_name <- substitute(arg)
  arg_value <- deparse(arg)
  paste0("  ", arg_name, " = ", arg_value, if (!last) ",")
}

travis_in <- function(x) {
  !all(is.na(match(c("travis", "all"), x)))
}

circle_in <- function(x) {
  !all(is.na(match(c("circle", "all"), x)))
}

appveyor_in <- function(x) {
  !all(is.na(match(c("appveyor", "all"), x)))
}

ci_menu <- function(choices, title) {
  choice_map <- c(
    travis = "Travis CI",
    circle = "Circle CI",
    appveyor = "AppVeyor CI",
    all = "All",
    none = "None"
  )

  reply <- menu(choice_map[choices], title = title)
  stopifnot(reply != 0)
  choices[reply]
}

use_tic_r <- function(repo_type) {
  use_tic_template(file.path(repo_type, "tic.R"), "tic.R")
}

# This code can only run interactively
# nocov end
