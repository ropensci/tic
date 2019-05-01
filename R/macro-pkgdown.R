#' do_pkgdown
#'
#' The [do_pkgdown()] macro adds the necessary steps for building
#' and deploying \pkg{pkgdown} documentation for a package.
#'
#' @include macro.R
#' @include macro-package-checks.R
#' @name macro
NULL


#' Build pkgdown documentation
#'
#' @description
#' `do_pkgdown()` builds and optionally deploys a pkgdown site and adds default steps
#'   to the `"install"`, `"before_deploy"` and `"deploy"` stages:
#'
#' @inheritParams step_build_pkgdown
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#' @inheritParams step_install_pkg
#' @param ... Passed on to [step_build_pkgdown()]
#' @family macros
#' @export
#' @examples
#' dsl_init()
#'
#' do_pkgdown()
#'
#' dsl_get()
do_pkgdown <- function(...,
                       deploy = NULL,
                       orphan = FALSE,
                       checkout = TRUE,
                       repos = repo_default(),
                       path = "docs", branch = "gh-pages",
                       remote_url = NULL,
                       commit_message = NULL, commit_paths = ".") {

  #' @param deploy `[flag]`\cr
  #'   If `TRUE`, deployment setup is performed before building the pkgdown site,
  #'   and the site is deployed after building it.
  #'   Set to `FALSE` to skip deployment.
  if (is.null(deploy)) {
    #'   By default (if `deploy` is `NULL`), deployment happens
    #'   if the following conditions are met:
    #'
    #'   1. The repo can be pushed to (see [ci_can_push()]).
    deploy <- ci_can_push()

    #'   2. The `branch` argument is `NULL`
    #'   (i.e., if the deployment happens to the active branch),
    #'   or the current branch is `master` (see [ci_get_branch()]).
    if (deploy && !is.null(branch)) {
      deploy <- (ci_get_branch() == "master")
    }
  }

  #' @description
  #' 1. [step_install_deps()] in the `"install"` stage, using the
  #'    `repos` argument.
  get_stage("install") %>%
    add_step(step_install_deps(repos = !!enquo(repos)))

  if (isTRUE(deploy)) {
    #' 1. [step_setup_ssh()] in the `"before_deploy"` to setup the upcoming deployment (if `deploy` is set),
    #' 1. [step_setup_push_deploy()] in the `"before_deploy"` stage (if `deploy` is set),
    get_stage("before_deploy") %>%
      add_step(step_setup_ssh()) %>%
      add_step(step_setup_push_deploy(
        path = !!enquo(path),
        branch = !!enquo(branch),
        remote_url = !!enquo(remote_url),
        orphan = !!enquo(orphan),
        checkout = !!enquo(checkout)
      ))
  }

  #' 1. [step_build_pkgdown()] in the `"deploy"` stage, forwarding all `...` arguments.
  get_stage("deploy") %>%
    add_step(step_build_pkgdown(!!!enquos(...)))

  #' 1. [step_do_push_deploy()] in the `"deploy"` stage.
  if (isTRUE(deploy)) {
    get_stage("deploy") %>%
      add_step(step_do_push_deploy(
        path = !!enquo(path),
        commit_message = !!enquo(commit_message),
        commit_paths = !!enquo(commit_paths)
      ))
  }

  #' @description
  #' By default, the `docs/` directory is deployed to the `gh-pages` branch, keeping the history.
}
