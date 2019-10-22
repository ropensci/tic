# This code can only run interactively
# nocov start

#' Initialize CI testing using tic
#'
#' Prepares a repo for building and deploying supported by \pkg{tic}.
#'
#' @param quiet `[flag]`\cr
#'   Less verbose output? Default: `FALSE`.
#'
#' @export
use_tic <- function(quiet = FALSE) {
  cli_alert("Welcome to {.pkg tic}!")
  cli_text(c(
    "This wizard will guide you through the setup process for getting started with various CI providers."
  ))

  cli_h1("Introduction:")
  cli_text("{.pkg tic} currently comes with support for three CI providers: ")

  cli_ul(c("Appveyor", "Circle CI", "Travis CI"))

  cli_par()
  cli_text(c("There is no need to use all of them.",
           " You can choose which one(s) you want to use and on which systems you want to build on.")
  )
  cli_end()

  cli_text("We recommend the following setup:")
  cli_ul(c("Appveyor: Windows", "Circle CI: Linux", "Travis CI: macOS"))

  if (yesno("Ready to get started?")) {
    return(invisible())
  }

  cli_h1("Choosing your setup.")
  cli_text("We'll ask you a few yes/no questions to gather your preferences.")

  windows = menu(c("Yes", "No"), title = "Do you want to build on Windows (= Appveyor)?")
  mac = menu(c("Yes", "No"), title = "Do you want to build on macOS (= Travis CI)?")

  linux = menu(c("Circle CI", "Travis CI", "None", "All"),
               title = "Which provider do you want to use for Linux builds?")

  deploy = menu(c("Circle CI", "Travis CI", "None", "All"),
                title = "Do you want to deploy (i.e. push from the CI build to your repo) on certain providers? If yes, which ones?")

  matrix = menu(c("Circle CI", "Travis CI", "Appveyor", "None", "All"),
                title = "Do you want to build on multiple R versions? (i.e. R-devel, R-release, R-oldrelease). If yes, on which platform(s)?")

  cli_h1("Setting up the CI providers.")

  cli_text("Now we are getting the selected CI providers ready for deployment.",
           "This requires some interaction with their API and you may need to create an API token.")

  # init deploy ----------------------------------------------------------------

  if (deploy == 1) {
    check_circle_pkg()
    circle::enable_project()
    circle::use_circle_deploy()
  } else if (deploy == 2) {
    travis::travis_enable()
    check_travis_pkg()
    travis::use_travis_deploy()
  } else if (deploy == 3) {
    travis::travis_enable()
    check_travis_pkg()

    check_circle_pkg()

    circle::use_circle_deploy()
    travis::use_travis_deploy()
  }

  # create YAMLS ---------------------------------------------------------------

  cli_h1("Creating YAML files.")

  cli_text("Next, we are creating the YAML files based on your selected preferences.")

  # Travis ---------------------------------------------------------------------

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
        use_travis_yml("linux=matrix")
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

 # Circle ----------------------------------------------------------------------






    if (matrix)

  } else if (deploy == 2) {
    travis::travis_enable()
    check_travis_pkg()
    travis::use_travis_deploy()
  } else if (deploy == 3) {
    travis::travis_enable()
    check_travis_pkg()

    check_circle_pkg()

    circle::use_circle_deploy()
    travis::use_travis_deploy()
  }





  # build and deploy on Travis
  if (linux == 2 && deploy == 2) {

  #' @details
  #' The project path is retrieved with [usethis::proj_get()].
  path <- usethis::proj_get()
  cli::cat_bullet(
    bullet = "info",
    paste0("Using active project ", usethis::ui_value(path))
  )

  repo_type <- detect_repo_type()

  if (needs_deploy(repo_type) && !is_installed("openssl")) {
  check_openssl_pkg()
  }

  #' 1. Enable Travis via [travis::travis_enable()]
  cli_alert_info("Step #1: Checking if Travis CI is enabled for this repo.")
  travis::travis_enable()

  cli_alert_info(c("Step #2: Creation of YAML file."))

  #' 1. Create a default `.travis.yml` file
  #'    (overwrite after confirmation in interactive mode only)
  use_travis_yml()


  # FIXME> We should offer templates for building on one R version and on devel/release/oldrel







  #' 1. Create a default `appveyor.yml` file
  #'    (depending on repo type, overwrite after confirmation
  #'    in interactive mode only)
  if (needs_appveyor(repo_type)) {
    use_appveyor_yml()
  }
  #' 1. Create a default `.circleci/config.yml` file
  #'    (depending on repo type, overwrite after confirmation
  #'    in interactive mode only)
  if (needs_circle(repo_type)) {
    use_circle_yml()
  }

  #' 1. Create a default `tic.R` file depending on the repo type
  #'    (package, website, bookdown, ...)
  use_tic_r(repo_type)

  #' 1. Enable deployment (if necessary, depending on repo type)
  #'    via [use_travis_deploy()]
  cli::cat_boxx(
    c(
      "Step #4: We create a SSH key pair",
      "to allow Travis deployment to GitHub."
    ),
    col = "green"
  )
  if (needs_deploy(repo_type)) use_travis_deploy()

  cli::cat_boxx(
    c(
      "Step #5: We create a GitHub PAT key on Travis CI",
      "to avoid GitHub API rate limitations in the builds."
    ),
    col = "green"
  )
  #' 1. Create a GitHub PAT and install it on Travis CI
  #'    via [travis::travis_set_pat()]
  travis::travis_set_pat()

  #'
  #' This function is aimed at supporting the most common use cases.
  #' Users who require more control are advised to review
  #' the source code of `use_tic()`
  #' and manually call the individual functions, some of which aren't exported.
}

use_travis_yml <- function() {
  use_tic_template(
    "dot-travis.yml",
    save_as = ".travis.yml",
    data = list(install_tic = double_quotes(get_install_tic_code()))
  )
}

use_appveyor_yml <- function() {
  use_tic_template(
    "appveyor.yml",
    data = list(install_tic = get_install_tic_code())
  )
}

use_circle_yml <- function() {
  use_tic_template(
    "circle.yml",
    save_as = ".circleci/config.yml",
    data = list(install_tic = get_install_tic_code())
  )
}

get_install_tic_code <- function() {
  if (getNamespaceVersion("tic") >= "1.0") {
    # We are on CRAN!
    "remotes::install_cran('tic', upgrade = 'always')"
  } else {
    "remotes::install_github('ropenscilabs/tic', upgrade = 'always')"
  }
}

double_quotes <- function(x) {
  gsub("'", '"', x, fixed = TRUE)
}

use_tic_r <- function(repo_type) {
  use_tic_template(file.path(repo_type, "tic.R"), "tic.R", open = TRUE)
}

use_tic_template <- function(template, save_as = template, open = FALSE,
                             ignore = TRUE, data = NULL) {
  usethis::use_template(
    template, save_as,
    package = "tic", open = open, ignore = ignore, data = data
  )
}

needs_appveyor <- function(repo_type) {
  repo_type == "package"
}

needs_circle <- function(repo_type) {
  repo_type == "package"
}

needs_deploy <- function(repo_type) {
  repo_type != "unknown"
}

use_github_interactive <- function() {
  if (!interactive()) {
    return()
  }
  if (travis::uses_github()) {
    return()
  }

  if (!yesno("Create GitHub repo and push code?")) {
    return()
  }

  message("Creating GitHub repository")
  usethis::use_github()
}

detect_repo_type <- function() {
  if (file.exists("_bookdown.yml")) {
    return("bookdown")
  }
  if (file.exists("_site.yml")) {
    return("site")
  }
  if (file.exists("config.toml")) {
    return("blogdown")
  }
  if (file.exists("DESCRIPTION")) {
    return("package")
  }

  if (!interactive()) {
    return("unknown")
  }

  cli::cat_bullet(
    "Unable to guess the repo type. ",
    "Please choose the desired one from the menu.",
    bullet = "warning"
  )

  choices <- c(
    blogdown = "Blogdown", bookdown = "Bookdown",
    package = "Package", website = "Website",
    unknown = "Other"
  )
  chosen <- utils::menu(choices)
  if (chosen == 0) {
    stopc("Aborted.")
  } else {
    names(choices)[[chosen]]
  }
}

yesno <- function(...) {
  utils::menu(c("Yes", "No"), title = paste0(...)) == 1
}

# This code can only run interactively
# nocov end
