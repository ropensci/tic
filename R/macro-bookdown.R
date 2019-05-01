#' do_bookdown
#'
#' The [do_bookdown()] macro adds the necessary steps for building
#' and deploying a \pkg{bookdown} book.
#'
#' @include macro.R
#' @include macro-pkgdown.R
#' @name macro
NULL


#' Build a bookdown book
#'
#' @description
#' `do_bookdown()` adds default steps related to package checks
#' to the `"install"`, `"before_deploy"`, `"script"` and `"deploy"` stages.
#'
#' @inheritParams step_build_bookdown
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#' @inheritParams step_install_pkg
#' @param ... Passed on to [step_build_bookdown()]
#' @family macros
#' @export
#' @examples
#' dsl_init()
#'
#' do_bookdown()
#'
#' dsl_get()
do_bookdown <- function(...,
                        deploy = NULL,
                        orphan = FALSE,
                        checkout = TRUE,
                        repos = repo_default(),
                        path = "_book", branch = "gh-pages",
                        remote_url = NULL,
                        commit_message = NULL, commit_paths = ".") {

  #' @param deploy `[flag]`\cr
  #'   If `TRUE`, deployment setup is performed before building the bookdown site,
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

  #' 1. [step_build_bookdown()] in the `"deploy"` stage, forwarding all `...` arguments.
  get_stage("deploy") %>%
    add_step(step_build_bookdown(!!!enquos(...)))

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
  #' By default, the `_book/` directory is deployed to the `gh-pages` branch, keeping the history.
}
