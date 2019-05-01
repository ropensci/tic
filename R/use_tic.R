#' Initialize CI testing using tic
#'
#' Prepares a repo for building and deploying supported by \pkg{tic}.
#'
#' @param quiet `[flag]`\cr
#'   Less verbose output? Default: `FALSE`.
#'
#' @export
use_tic <- function(quiet = FALSE) {
  cli::cat_boxx("Welcome to `tic`!", col = "green")
  cli::cat_bullet(
    "This wizard will set all the required tokens and files\n  on Travis CI and Github. Let's get started!",
    bullet = "info"
  )

  #' @details
  #' This function requires the \pkg{travis} and \pkg{usethis} packages.
  if (!is_installed("travis")) {
    cli::cat_rule(col = "red")
    stopc('use_tic() needs the `travis` package. Please install it using remotes::install_github("ropenscilabs/travis").')
  }

  if (!is_installed("usethis")) {
    cli::cat_rule(col = "red")
    stopc('use_tic() needs the `usethis` package, please install using install.packages("usethis").')
  }

  #' @details
  #' The project path is retrieved with [usethis::proj_get()].
  path <- usethis::proj_get()
  cli::cat_bullet(
    bullet = "info",
    paste0("Using active project ", usethis::ui_value(path))
  )

  #' @details
  #' The preparation consists of the following steps:
  #' 1. If necessary, create a GitHub repository via [usethis::use_github()]
  #'
  cli::cat_boxx("Step #1: We check if a Github repository exists.", col = "green")

  use_github_interactive()
  if (!isTRUE(travis::uses_github())) {
    stop("A Github repository is needed. Please create one manually or re-run the wizard to do it automatically.")
  } else {
    cli::cat_bullet("Github repo exists.", bullet = "tick", bullet_col = "green")
  }

  #' 1. Enable Travis via [travis::travis_enable()]
  cli::cat_boxx("Step #2: We check if Travis is already enabled.", col = "green")
  travis::travis_enable()

  cli::cat_boxx(c("Step #3: We create new files", "`.travis.yml`, `appveyor.yml` and `tic.R`."), col = "green")

  #' 1. Create a default `.travis.yml` file
  #'    (overwrite after confirmation in interactive mode only)
  use_travis_yml()
  #' 1. Create a default `appveyor.yml` file
  #'    (depending on repo type, overwrite after confirmation
  #'    in interactive mode only)
  repo_type <- detect_repo_type()
  if (needs_appveyor(repo_type)) use_appveyor_yml()

  #' 1. Create a default `tic.R` file depending on the repo type
  #'    (package, website, bookdown, ...)
  use_tic_r(repo_type)

  #' 1. Enable deployment (if necessary, depending on repo type)
  #'    via [travis::use_travis_deploy()]
  cli::cat_boxx(c("Step #4: We create a SSH key pair", "to allow Travis deployment to Github."), col = "green")
  if (needs_deploy(repo_type)) travis::use_travis_deploy()

  cli::cat_boxx(c("Step #5: We create a Github PAT key on Travis CI", "to avoid Github API rate limitations in the builds."), col = "green")
  #' 1. Create a GitHub PAT and install it on Travis CI via [travis::travis_set_pat()]
  travis::travis_set_pat()

  #'
  #' This function is aimed at supporting the most common use cases.
  #' Users who require more control are advised to manually call the individual
  #' functions.
}

use_travis_yml <- function() {
  use_tic_template("dot-travis.yml", save_as = ".travis.yml")
}

use_appveyor_yml <- function() {
  use_tic_template("appveyor.yml")
}

use_tic_r <- function(repo_type) {
  use_tic_template(file.path(repo_type, "tic.R"), "tic.R", open = TRUE)
}

use_tic_template <- function(template, save_as = template, open = FALSE) {
  usethis::use_template(template, save_as, package = "tic", open = open)
}

needs_appveyor <- function(repo_type) {
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

  if (!interactive()) return("unknown")

  cli::cat_bullet("Unable to guess the repo type. Please choose the desired one from the menu.",
    bullet = "warning")

  choices <- c(
    blogdown = "Blogdown", bookdown = "Bookdown",
    package = "Package", website = "Website",
    unknown = "Other"
  )
  chosen <- menu(choices)
  if (chosen == 0) {
    stopc("Aborted.")
  } else {
    names(choices)[[chosen]]
  }
}

yesno <- function(...) {
  utils::menu(c("Yes", "No"), title = paste0(...)) == 1
}
