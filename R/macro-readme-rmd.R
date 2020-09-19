#' do_readme_rmd
#'
#' The [do_readme_rmd()] macro renders an R Markdown README and deploys
#' the rendered README.md file to Github.
#'
#' @include macro.R
#' @include macro-package-checks.R
#' @name macro
NULL

#' Render a R Markdown README and deploy to Github
#'
#' @description
#' \Sexpr[results=rd, stage=render]{lifecycle::badge("experimental")}
#'
#' `do_readme_rmd()` renders an R Markdown README and deploys
#' the rendered README.md file to Github. It adds default steps to the
#' `"before_deploy"` and `"deploy"` stages:
#'
#' @inheritParams step_setup_ssh
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#' @template private_key_name
#'
#' @family macros
#' @export
#' @examples
#' \dontrun{
#' dsl_init()
#'
#' do_readme_rmd()
#'
#' dsl_get()
#' }
do_readme_rmd <- function(checkout = TRUE,
                          remote_url = NULL,
                          commit_message = NULL,
                          force = FALSE,
                          private_key_name = "TIC_DEPLOY_KEY") {

  #' @description
  #' 1. [step_setup_ssh()] in the `"before_deploy"` to setup
  #'    the upcoming deployment
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh(private_key_name = !!enquo(private_key_name)))

  #' 1. [step_setup_push_deploy()] in the `"before_deploy"` stage
  get_stage("before_deploy") %>%
    add_step(step_setup_push_deploy(
      path = ".",
      branch = github_info()$default_branch,
      remote_url = !!enquo(remote_url),
      orphan = FALSE,
      checkout = !!enquo(checkout)
    ))

  #' 1. `rmarkdown::render()` in the `"deploy"` stage
  get_stage("deploy") %>%
    add_code_step(rmarkdown::render("README.Rmd"))

  #' 1. [step_do_push_deploy()] in the `"deploy"` stage.
  get_stage("deploy") %>%
    add_step(step_do_push_deploy(
      path = ".",
      commit_message = !!enquo(commit_message),
      commit_paths = "README.md",
      force = !!enquo(force)
    ))

  dsl_get()
}
