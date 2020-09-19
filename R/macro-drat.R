#' do_drat
#'
#' The [do_drat()] macro adds the necessary steps for building
#' and deploying a drat repository to host R package sources.
#'
#' @include macro.R
#' @include macro-package-checks.R
#' @name macro
NULL

#' Build and deploy drat repository
#'
#' @description
#' `do_drat()` builds and deploys R packages to a drat repository and adds
#' default steps to the `"install"`, `"before_deploy"` and `"deploy"` stages:
#'
#' @inheritParams step_add_to_drat
#' @inheritParams step_setup_ssh
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#' @param path,branch By default, this macro deploys the default repo branch
#'   (usually "master") of the drat repository.
#'   An alternative option is `"gh-pages"`.
#' @template private_key_name
#'
#' @section Deployment:
#'   Deployment can only happen to the default repo branch (usually "master") or
#'   `gh-pages` branch because the GitHub Pages functionality from GitHub is
#'   used to access the drat repository later on. You need to enable this
#'   functionality when creating the drat repository on GitHub via `Settings ->
#'   GitHub pages` and set it to the chosen setting here.
#'
#'   To build and deploy Windows binaries, builds on Travis CI with deployment
#'   permissions need to be triggered. To build and deploy macOS binaries,
#'   builds on Travis CI with deployment permissions need to be triggered. Have
#'   a look at \url{https://docs.ropensci.org/tic/articles/deployment.html} for
#'   more information and instructions.
#' @family macros
#' @export
#' @examples
#' dsl_init()
#'
#' do_drat()
#'
#' dsl_get()
do_drat <- function(repo_slug = NULL,
                    orphan = FALSE,
                    checkout = TRUE,
                    path = "~/git/drat",
                    branch = NULL,
                    remote_url = NULL,
                    commit_message = NULL,
                    commit_paths = ".",
                    force = FALSE,
                    private_key_name = "TIC_DEPLOY_KEY",
                    deploy_dev = FALSE) {

  if (is.null(branch)) {
    branch <- github_info()$default_branch
  }

  #' @description
  #' 1. [step_setup_ssh()] in the `"before_deploy"` to setup
  #'    the upcoming deployment
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh(private_key_name = private_key_name))

  #' 1. [step_setup_push_deploy()] in the `"before_deploy"` stage
  #'    (if `deploy` is set),
  get_stage("before_deploy") %>%
    add_step(step_setup_push_deploy(
      path = !!enquo(path),
      branch = !!enquo(branch),
      remote_url = paste0("git@github.com:", repo_slug, ".git"),
      orphan = !!enquo(orphan),
      checkout = !!enquo(checkout)
    ))

  #' 1. [step_add_to_drat()] in the `"deploy"`
  get_stage("deploy") %>%
    add_step(step_add_to_drat(
      repo_slug = repo_slug, deploy_dev = deploy_dev
    ))

  #' 1. [step_do_push_deploy()] in the `"deploy"` stage.
  get_stage("deploy") %>%
    add_step(step_do_push_deploy(
      path = !!enquo(path),
      commit_message = !!enquo(commit_message),
      commit_paths = !!enquo(commit_paths),
      force = !!enquo(force)
    ))

  dsl_get()
}
