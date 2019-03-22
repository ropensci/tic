BuildBookdown <- R6Class(
  "BuildBookdown", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function(...) {
      private$bookdown_args <- list(...)
      super$initialize()
    },

    run = function() {
      remotes::install_local(".")
      do.call(bookdown::render_book, private$bookdown_args)
    },

    prepare = function() {
      verify_install(c("pkgdown", "remotes"))

      remotes::install_deps(dependencies = TRUE)

      # Using a separate library for "build dependencies"
      # (which might well be ahead of CRAN)
      # works very poorly with custom steps that are not aware
      # of this shadow library.
      inst <- installed.packages()
      installed_pkg <- rownames(inst)
      is_priority <- inst[, "Priority"] %in% c("base", "recommended")
      priority_pkg <- installed_pkg[is_priority]
      pkg_to_update <- setdiff(installed_pkg, priority_pkg)
      remotes::update_packages(pkg_to_update)
    }
  ),

  private = list(
    bookdown_args = NULL
  )

)

#' Step: Build a bookdown book
#'
#' Check a package using [bookdown::render_book()],
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
#' @param ... Passed on to `bookdown::render_book()`
#'
#' @export
step_build_bookdown <- function(...) {
  BuildBookdown$new(...)
}
