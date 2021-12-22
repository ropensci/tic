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
#' `do_pkgdown()` builds and optionally deploys a pkgdown site and adds default
#' steps to the `"install"`, `"before_deploy"` and `"deploy"` stages:
#'
#' @inheritParams step_build_pkgdown
#' @inheritParams step_setup_push_deploy
#' @inheritParams step_do_push_deploy
#' @inheritParams step_install_pkg
#' @param path,branch By default, this macro deploys the `docs` directory
#'   to the `gh-pages` branch. This is different from [step_push_deploy()].
#' @template private_key_name
#' @param ... Passed on to [step_build_pkgdown()]
#' @family macros
#' @export
#' @examples
#' \dontrun{
#' dsl_init()
#'
#' do_pkgdown()
#'
#' dsl_get()
#' }
do_pkgdown <- function(...,
                       deploy = NULL,
                       orphan = FALSE,
                       checkout = TRUE,
                       repos = repo_default(),
                       path = "docs",
                       branch = "gh-pages",
                       remote_url = NULL,
                       commit_message = NULL,
                       commit_paths = ".",
                       force = FALSE,
                       private_key_name = "TIC_DEPLOY_KEY") {

  #' @param deploy `[flag]`\cr
  #'   If `TRUE`, deployment setup is performed
  #'   before building the pkgdown site,
  #'   and the site is deployed after building it.
  #'   Set to `FALSE` to skip deployment.
  if (is.null(deploy)) {
    #'   By default (if `deploy` is `NULL`), deployment happens
    #'   if the following conditions are met:
    #'
    #'   1. The repo can be pushed to (see [ci_can_push()]).
    #'      account for old default "id_rsa"
    deploy <- ci_can_push(private_key_name = private_key_name)

    if (!deploy) {
      cli::cli_alert_info("{.field tic}: Only building pkgdown website, not deploying it
          because we are lacking push permissions to the repo. Did you add
          a SSH key pair via {.fun tic::use_ghactions_deploy}?", wrap = TRUE)
    }

    #'   2. The `branch` argument is `NULL`
    #'      (i.e., if the deployment happens to the active branch),
    #'      or the current branch is the default branch,
    #'      or contains "cran-" in its name (for compatibility with \pkg{fledge})
    #'      (see [ci_get_branch()]).
    print(sprintf("DEBUG: Branch: %s, ENV_VAR: %s", ci_get_branch(), Sys.getenv("GITHUB_BASE_REF")))
    if (deploy && !is.null(branch)) {
      deploy <- (ci_get_branch() == github_info()$default_branch ||
        grepl("cran-", ci_get_branch()))
      if (!deploy) {
        cli::cli_alert_info("{.field tic}: Only building pkgdown website, not
          deploying it since we are not on the default branch or a branch which
          contains 'cran' in its name but on branch
          '{.field {tic::ci_get_branch()}}'.", wrap = TRUE)
      }
    }
  }

  #' @description
  #' 1. [step_install_deps()] in the `"install"` stage, using the
  #'    `repos` argument.
  #' 1. [step_session_info()] in the `"install"` stage.
  get_stage("install") %>%
    add_step(step_install_deps(repos = !!enquo(repos))) %>%
    add_step(step_session_info())

  if (isTRUE(deploy)) {
    #' 1. [step_setup_ssh()] in the `"before_deploy"` to setup
    #'    the upcoming deployment (if `deploy` is set and only on
    #'    GitHub Actions),
    if (ci_on_ghactions()) {
      get_stage("before_deploy") %>%
        add_step(step_setup_ssh(private_key_name = private_key_name))
    }

    #' 1. [step_setup_push_deploy()] in the `"before_deploy"` stage
    #'    (if `deploy` is set),
    get_stage("before_deploy") %>%
      add_step(step_setup_push_deploy(
        path = !!enquo(path),
        branch = !!enquo(branch),
        remote_url = !!enquo(remote_url),
        orphan = !!enquo(orphan),
        checkout = !!enquo(checkout)
      ))
  }

  #' 1. [step_build_pkgdown()] in the `"deploy"` stage,
  #'    forwarding all `...` arguments.
  get_stage("deploy") %>%
    add_step(step_build_pkgdown(!!!enquos(...))) %>%
    add_code_step(writeLines("", paste0(!!path, "/.nojekyll"))) %>%
    add_code_step(dir.create(paste0(!!path, "/dev"), showWarnings = FALSE)) %>%
    add_code_step(writeLines("", paste0(!!path, "/dev/.nojekyll")))

  #' 1. [step_do_push_deploy()] in the `"deploy"` stage.
  if (isTRUE(deploy)) {
    get_stage("deploy") %>%
      add_step(step_do_push_deploy(
        path = !!enquo(path),
        commit_message = !!enquo(commit_message),
        commit_paths = !!enquo(commit_paths),
        force = !!enquo(force)
      ))
  }

  #' @description
  #' By default, the `docs/` directory is deployed to the `gh-pages` branch,
  #' keeping the history.

  dsl_get()
}
