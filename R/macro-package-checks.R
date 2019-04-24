#' do_package_checks
#'
#' The [do_package_checks()] macro adds default checks for R packages,
#' including installation of dependencies and running a test coverage
#' analysis.
#'
#' @include macro.R
#' @name macro
NULL

#' Add default checks for packages
#'
#' @description
#' `do_package_checks()` adds default steps related to package checks
#' to the `"before_install"`, `"install"`, `"script"` and `"after_success"`
#' stages:
#'
#' @inheritParams step_rcmdcheck
#' @param codecov `[flag]`\cr Whether to include a step running
#'   `covr::codecov(quiet = FALSE)` (default: only for non-interactive CI,
#'   see [ci_is_interactive()]).
#' @family macros
#' @export
#' @importFrom magrittr %>%
do_package_checks <- function(...,
                              codecov = !ci_is_interactive(),
                              warnings_are_errors = NULL,
                              notes_are_errors = NULL,
                              args = c("--no-manual", "--as-cran"),
                              build_args = "--force", error_on = "warning",
                              repos = repo_default(), timeout = Inf) {
  #' @description
  #' 1. [step_install_deps()] in the `"install"` stage, using the
  #'    `repos` argument.
  get_stage("install") %>%
    add_step(
      step_install_deps(repos = repos)
    )

  #' 1. [step_rcmdcheck()] in the `"script"` stage, using the
  #'    `warnings_are_errors`, `notes_are_errors`, `args`, and
  #'    `build_args` arguments.
  get_stage("script") %>%
    add_step(
      step_rcmdcheck(
        warnings_are_errors = warnings_are_errors,
        notes_are_errors = notes_are_errors,
        args = args,
        build_args = build_args,
        error_on = error_on,
        repos = repos,
        timeout = timeout
      )
    )

  if (isTRUE(codecov)) {
    #' 1. A call to [covr::codecov()] in the `"after_success"` stage (only if the `codecov` flag is set)
    get_stage("after_success") %>%
      add_code_step(covr::codecov(quiet = FALSE))
  }
}
