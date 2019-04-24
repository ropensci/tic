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
#' @param build_only To be removed
#' @family macros
#' @export
#' @importFrom magrittr %>%
do_bookdown <- function(...,
                        build_only = FALSE,
                        orphan = FALSE,
                        checkout = TRUE,
                        repos = repo_default(),
                        path = "_book", branch = "gh-pages",
                        remote_url = NULL,
                        commit_message = NULL, commit_paths = ".") {

  #' @description
  #' 1. A [step_install_deps()] in the `"install"` stage, using the
  #'    `repos` argument.
  get_stage("install") %>%
    add_step(step_install_deps(repos = repos))

  needs_deploy <- !isTRUE(build_only) && ci_can_push()

  if (isTRUE(needs_deploy)) {
    ci_cat_with_color("`build_only = TRUE` was set, skipping deployment")
  } else {

    #' 1. [step_setup_ssh()] in the `"before_deploy"` to setup the upcoming deployment.
    #' 1. [step_setup_push_deploy()] in the `"before_deploy"` stage.
    #' 1. [step_build_bookdown()] in the `"deploy"` stage
    #' 1. [step_do_push_deploy()] in the `"deploy"` stage. By default, the deploy is done to the gh-pages branch.
    get_stage("before_deploy") %>%
      add_step(step_setup_ssh()) %>%
      add_step(step_setup_push_deploy(
        path = path, branch = branch,
        remote_url = remote_url, orphan = orphan, checkout = checkout
      ))
  }

  get_stage("script") %>%
    add_step(step_build_bookdown(...))


  if (isTRUE(needs_deploy)) {
    ci_cat_with_color("`build_only = TRUE` was set, skipping deployment")
  } else {
    get_stage("deploy") %>%
      add_step(step_do_push_deploy(
        path = path, commit_message = commit_message, commit_paths = commit_paths
      ))
  }
}
