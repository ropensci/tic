#' Initialize CI testing using tic
#'
#' Prepares a repo for building and deploying supported by \pkg{tic}.
#'
#' @param path `[string]`\cr
#'   The path to the repo to prepare.
#' @param quiet `[flag]`\cr
#'   Less verbose output? Default: `FALSE`.
#'
#' @export
use_tic <- function(path = ".", quiet = FALSE) {
  if (!rlang::is_installed("travis")) {
    stopc('`use_tic()` needs the travis package, please install using `remotes::install_github("ropenscilabs/travis")`.')
  }

  if (!rlang::is_installed("usethis")) {
    stopc('`use_tic()` needs the usethis package, please install using `install.packages("usethis")`.')
  }

  #' @details
  #' The preparation consists of the following steps:
  withr::with_dir(path, {
    #' 1. If necessary, create a GitHub repository via [usethis::use_github()]
    use_github_interactive()
    stopifnot(travis::uses_github())

    #' 1. Enable Travis via [travis::travis_enable()]
    travis::travis_enable()
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
    if (needs_deploy(repo_type)) travis::use_travis_deploy()

    #' 1. Create a GitHub PAT and install it on Travis CI via [travis::travis_set_pat()]
    travis::travis_set_pat()
  })

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
  use_tic_template(file.path(repo_type, "tic.R"), "tic.R")
}

use_tic_template <- function(template, save_as = template) {
  usethis::use_template(template, save_as, package = "tic")
}

needs_appveyor <- function(repo_type) {
  repo_type == "package"
}

needs_deploy <- function(repo_type) {
  repo_type != "unknown"
}

use_github_interactive <- function() {
  if (!interactive()) return()
  if (travis::uses_github()) return()

  if (!yesno("Create GitHub repo and push code?")) return()

  message("Creating GitHub repository")
  usethis::use_github()
}


detect_repo_type <- function() {
  if (file.exists("_bookdown.yml")) return("bookdown")
  if (file.exists("_site.yml")) return("site")
  if (file.exists("config.toml")) return("blogdown")
  if (file.exists("DESCRIPTION")) return("package")
  "unknown"
}

yesno <- function(...) {
  utils::menu(c("Yes", "No"), title = paste0(...)) == 1
}
