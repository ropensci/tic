#' Shortcuts for accessing CRAN-like repositories
#'
#' These functions can be used as convenient shortcuts
#' for the `repos` argument to e.g. [do_package_checks()] and
#' [step_install_deps()].
#' @name repo
NULL

#' @rdname repo
#' @export
repo_default <- function() {
  #' @description
  #' `repo_default()` returns [getOption("repos")], defaulting to `repo_cloud()`.
  getOption("repos", default = repo_cloud())
}

#' @rdname repo
#' @export
repo_cloud <- function() {
  #' @description
  #' `repo_cloud()` returns RStudio's CRAN mirror.
  c(CRAN = https("cloud.r-project.org"))
}

#' @rdname repo
#' @export
repo_cran <- function() {
  #' @description
  #' `repo_cran()` returns the master CRAN repo.
  c(CRAN = https("cran.r-project.org"))
}

#' @rdname repo
#' @param base The base repo to use, defaults to `repo_default()`.
#'   Pass `NULL` to install only from Bioconductor repos.
#' @export
repo_bioc <- function(base = repo_default()) {
  #' @description
  #' `repo_bioc()` returns Bioconductor repos from
  #' [remotes::bioc_install_repos()], in addition to the default repo.
  c(cran, remotes::bioc_install_repos())
}

https <- function(x) {
  if (getRversion() >= "3.2") {
    paste0("https://", x)
  } else {
    paste0("http://", x)
  }
}
