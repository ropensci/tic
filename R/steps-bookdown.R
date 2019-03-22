BuildBookdown <- R6Class(
  "BuildBookdown", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function() {
    },

    run = function() {
      res <- bookdown::render("")
    },

    prepare = function() {
      verify_install("bookdown")
      super$prepare()
    }
  ),

  private = list(
    args = NULL,
    build_args = NULL,
    error_on = NULL,
    repos = NULL,
    timeout = NULL
  )
)

#' Step: Build a bookdown book
#'
#' Check a package using [bookdown::render()],
#' which ultimately calls `R CMD check`.
#' The preparation consists of installing package dependencies
#' via [remotes::install_deps()] with `dependencies = TRUE`,
#' and updating all packages.
#'
#' @section Updating of (dependency) packages:
#' Packages shipped with the R-installation will not be updated as they will be
#' overwritten by the Travis R-installer in each build.
#' If you want these package to be updated, please add the following
#' step to your workflow: `add_code_step(remotes::update_packages(<pkg>)`.
#'
#' @export
step_bookdown <- function() {
  BuildBookdown$new(
  )
}
