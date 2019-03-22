BuildBookdown <- R6Class(
  "BuildBookdown", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function() {
    },

    run = function() {
      do.call(bookdown::render_book, private$pkgdown_args)
    },

    prepare = function() {
      verify_install("bookdown")

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
    pkgdown_args = NULL
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
#' @param ... Passed on to `pkgdown::build_site()`
#'
#' @export
step_bookdown <- function(...) {
  BuildBookdown$new(...)
}
