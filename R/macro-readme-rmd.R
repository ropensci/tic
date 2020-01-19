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
#' `do_readme_rmd()` renders an R Markdown README and deploys
#' the rendered README.md file to Github. It adds default steps to the
#' `"before_deploy"` and `"deploy"` stages:
#'
#' @inheritParams step_setup_ssh
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#' @param path,branch By default, this macro deploys the `"master"` branch
#'   of the readme_rmd repository. An alternative option is `"gh-pages"`.
#' @param ssh_key_name `string`\cr
#'   The name of the private SSH key which should be used for deployment.
#'
#' @family macros
#' @export
#' @examples
#' dsl_init()
#'
#' do_readme_rmd()
#'
#' dsl_get()
do_readme_rmd <- function(checkout = TRUE,
                          path = ".",
                          branch = "master",
                          remote_url = NULL,
                          commit_message = NULL,
                          ssh_key_name = "id_rsa") {

  #' @description
  #' 1. [step_setup_ssh()] in the `"before_deploy"` to setup
  #'    the upcoming deployment
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh(name = ssh_key_name))

  #' 1. [step_setup_push_deploy()] in the `"before_deploy"` stage
  get_stage("before_deploy") %>%
    add_step(step_setup_push_deploy(
      path = !!enquo(path),
      branch = !!enquo(branch),
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
      path = !!enquo(path),
      commit_message = !!enquo(commit_message),
      commit_paths = "README.md"
    ))

  dsl_get()
}
