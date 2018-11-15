TicStepWithPackageDeps <- R6Class(
  "TicStepWithPackageDeps", inherit = TicStep,

  public = list(
    initialize = function() {},

    prepare = function() {
      verify_install("remotes")

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
)

RCMDcheck <- R6Class(
  "RCMDcheck", inherit = TicStepWithPackageDeps,

  public = list(
    initialize = function(args = c("--no-manual", "--as-cran"),
                          build_args = "--force", error_on = "warning",
                          repos = getOption("repos"), timeout = Inf) {
      private$args <- args
      private$build_args <- build_args
      private$error_on <- error_on
      private$repos <- repos
      private$timeout <- timeout

      super$initialize()
    },

    run = function() {
      res <- rcmdcheck::rcmdcheck(args = private$args,
                                  build_args = private$build_args,
                                  error_on = "never",
                                  repos = private$repos,
                                  timeout = private$timeout
                                  )

      print(res)
      if (length(res$errors) > 0) {
        stopc("Errors found.")
      }
      if (any(private$error_on == "warning") && length(res$warnings) > 0) {
        stopc("Warnings found, and `errors_on = 'warning'` is set.")
      }
      if (any(private$error_on == "notes") && length(res$notes) > 0) {
        stopc("Notes found, and `errors_on = 'note'` is set.")
      }
    },

    prepare = function() {
      verify_install("rcmdcheck")
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

#' Step: Check a package
#'
#' Check a package using \pkg{rcmdcheck}, which ultimately calls `R CMD check`.
#' The preparation consists of installing package dependencies
#' via [remotes::install_deps()] with `dependencies = TRUE`,
#' and updating all packages.
#'
#' This step uses a dedicated library,
#' a subdirectory `tic-pkg` of the current user library
#' (the first element of [.libPaths()]),
#' for the checks.
#' This is done to minimize conflicts between dependent packages
#' and packages that are required for running the various steps.
#'
#' @section Updating of (dependency) packages:
#' Packages shipped with the R-installation will not be updated as they will be
#' overwritten by the Travis R-installer in each build.
#' If you want these package to be updated, please add the following
#' step to your workflow: `add_code_step(remotes::update_packages(<pkg>)`.
#'
#' @param warnings_are_errors `[flag]`\cr
#'   Should warnings be treated as errors? Default: `TRUE`.
#' @param notes_are_errors `[flag]`\cr
#'   Should notes be treated as errors? Default: `FALSE`.
#' @param args `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `c("--no-manual", "--as-cran")`.
#' @param build_args `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `"--force"`.
#' @param error_on `[character]`\cr
#'   Whether to throw an error on R CMD check failures. Note that the check is
#'   always completed (unless a timeout happens), and the error is only thrown
#'   after completion. If "never", then no errors are thrown. If "error", then
#'   only ERROR failures generate errors. If "warning", then WARNING failures
#'   generate errors as well. If "note", then any check failure generated an
#'   error.
#' @param repos `[character]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `getOption("repos")`.
#' @param timeout `[numeric]`\cr
#'   Passed to `rcmdcheck::rcmdcheck()`, default:
#'   `Inf`.
#' @export
step_rcmdcheck <- function(args = c("--no-manual", "--as-cran"),
                           build_args = "--force", error_on = "warning",
                           repos = getOption("repos"), timeout = Inf) {
  RCMDcheck$new(
    args = args,
    build_args = build_args,
    error_on = error_on,
    repos = repos,
    timeout = timeout
  )
}
