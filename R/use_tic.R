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
#' @param quiet `[flag]`\cr Less verbose output? Default: `FALSE`.
#' @export
use_tic <- function(quiet = FALSE) { # nolint
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
  cli_ul(c("Appveyor: Windows", "Circle CI: Linux", "Travis CI: macOS"))
  cli_par()
  cli_end()

  if (yesno("Ready to get started?")) {
    return(invisible(NULL))
  }

  cli_h1("Choosing your setup.")
  cli_text("We'll ask you a few yes/no questions to gather your preferences.")
  cli_par()
  cli_end()

  windows <- menu(c("Yes", "No"),
    title = "Do you want to build on Windows (= Appveyor)?"
  )
  mac <- menu(c("Yes", "No"),
    title = "Do you want to build on macOS (= Travis CI)?"
  )

  linux <- menu(c("Circle CI", "Travis CI", "None", "All"),
    title = "Which provider do you want to use for Linux builds?"
  )

  deploy <- menu(c("Circle CI", "Travis CI", "No", "All"),
    title = "Do you want to deploy (i.e. push from the CI build to your repo) on certain providers? If yes, which ones?" # nolint
  )

  matrix <- menu(c("Circle CI", "Travis CI", "Appveyor", "No", "All"),
    title = "Do you want to build on multiple R versions? (i.e. R-devel, R-release, R-oldrelease). If yes, on which platform(s)?" # nolint
  )

  cli_h1("Setting up the CI providers.")

  cli_text(
    "Next we are getting the selected CI providers ready for deployment.",
    " This requires some interaction with their API and you may need to create
    an API token."
  )
  cli_par()
  cli_end()

  # init deploy ----------------------------------------------------------------

  if (deploy == 1) {
    rule(left = "Circle CI")
    check_circle_pkg()
    circle::enable_repo()
    circle::use_circle_deploy()
  } else if (deploy == 2) {
    rule(left = "Travis CI")
    travis::travis_enable()
    check_travis_pkg()
    travis::use_travis_deploy()
  } else if (deploy == 3) {
    rule(left = "Travis CI")
    check_travis_pkg()
    travis::travis_enable()
    travis::use_travis_deploy()

    rule(left = "Circle CI")
    check_circle_pkg()
    circle::enable_repo()
    circle::use_circle_deploy()
  }

  # create YAMLs ---------------------------------------------------------------

  cli_par()
  cli_end()
  cli_h1("Creating YAML files...")

  # Travis ---------------------------------------------------------------------

  rule(left = "Travis CI")

  if (linux == 2 || linux == 4) {
    # deployment
    if (deploy == 2 || deploy == 4) {
      # build matrix
      if (matrix == 2 || matrix == 5) {
        use_travis_yml("linux-deploy-matrix")
      } else {
        use_travis_yml("linux-deploy")
      }
    } else {
      # build matrix
      if (matrix == 2 || matrix == 5) {
        use_travis_yml("linux-matrix")
      } else {
        use_travis_yml("linux")
      }
    }
  } else if (mac == 1) {
    if (deploy == 2 || deploy == 4) {
      # build matrix
      if (matrix == 2 || matrix == 5) {
        use_travis_yml("macos-deploy-matrix")
      } else {
        use_travis_yml("macos-deploy")
      }
    } else {
      # build matrix
      if (matrix == 2 || matrix == 5) {
        use_travis_yml("macos-matrix")
      } else {
        use_travis_yml("macos")
      }
    }
  }

  # Circle ---------------------------------------------------------------------

  Sys.sleep(3)
  rule(left = "Circle CI")

  if (linux == 1 || linux == 4) {
    # deployment
    if (deploy == 1 || deploy == 4) {
      # build matrix
      if (matrix == 1 || matrix == 5) {
        use_circle_yml("linux-deploy-matrix")
      } else {
        use_circle_yml("linux-deploy")
      }
    } else {
      # build matrix
      if (matrix == 1 || matrix == 5) {
        use_circle_yml("linux-matrix")
      } else {
        use_circle_yml("linux")
      }
    }
  }

  # Appveyor -------------------------------------------------------------------

  Sys.sleep(3)
  rule(left = "Appveyor CI")

  if (windows == 1) {
    if (matrix == 3 || matrix == 5) {
      use_appveyor_yml("windows-matrix")
    } else {
      use_appveyor_yml("windows")
    }
  }

  # tic.R ----------------------------------------------------------------------

  Sys.sleep(3)
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

use_tic_r <- function(repo_type) {
  use_tic_template(file.path(repo_type, "tic.R"), "tic.R")
}

# This code can only run interactively
# nocov end
