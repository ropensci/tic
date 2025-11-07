# Package index

## DSL

- [`tic`](https://docs.ropensci.org/tic/dev/reference/tic-package.md)
  [`tic-package`](https://docs.ropensci.org/tic/dev/reference/tic-package.md)
  : tic: Tasks Integrating Continuously: CI-Agnostic Workflow
  Definitions
- [`get_stage()`](https://docs.ropensci.org/tic/dev/reference/dsl.md)
  [`add_step()`](https://docs.ropensci.org/tic/dev/reference/dsl.md)
  [`add_code_step()`](https://docs.ropensci.org/tic/dev/reference/dsl.md)
  : tic's domain-specific language
- [`dsl_get()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md)
  [`dsl_load()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md)
  [`dsl_init()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md)
  : Stages and steps

## YAML templates

- [`update_yml()`](https://docs.ropensci.org/tic/dev/reference/update_yml.md)
  : Update tic YAML Templates
- [`use_circle_yml()`](https://docs.ropensci.org/tic/dev/reference/yaml_templates.md)
  [`use_ghactions_yml()`](https://docs.ropensci.org/tic/dev/reference/yaml_templates.md)
  : Use CI YAML templates
- [`use_update_tic()`](https://docs.ropensci.org/tic/dev/reference/use_update_tic.md)
  : Update tic Templates

## Macros

- [`macro`](https://docs.ropensci.org/tic/dev/reference/macro.md) :
  Macros
- [`do_blogdown()`](https://docs.ropensci.org/tic/dev/reference/do_blogdown.md)
  : Build a blogdown site
- [`do_bookdown()`](https://docs.ropensci.org/tic/dev/reference/do_bookdown.md)
  : Build a bookdown book
- [`do_drat()`](https://docs.ropensci.org/tic/dev/reference/do_drat.md)
  : Build and deploy drat repository
- [`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md)
  : Add default checks for packages
- [`do_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/do_pkgdown.md)
  : Build pkgdown documentation
- [`do_readme_rmd()`](https://docs.ropensci.org/tic/dev/reference/do_readme_rmd.md)
  **\[experimental\]** : Render a R Markdown README and deploy to Github
- [`list_macros()`](https://docs.ropensci.org/tic/dev/reference/list_macros.md)
  : List available macros

## Steps

- [`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md)
  : Step: Add built package to a drat
- [`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md)
  : Step: Add to known hosts
- [`step_build_blogdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_blogdown.md)
  : Step: Build a Blogdown Site
- [`step_build_bookdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_bookdown.md)
  : Step: Build a bookdown book
- [`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md)
  : Step: Build pkgdown documentation
- [`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md)
  : Step: Perform push deploy
- [`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md)
  : Step: Hello, world!
- [`step_install_deps()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md)
  [`step_install_cran()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md)
  [`step_install_github()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md)
  : Step: Install packages
- [`step_install_ssh_keys()`](https://docs.ropensci.org/tic/dev/reference/step_install_ssh_keys.md)
  : Step: Install an SSH key
- [`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md)
  : Step: Setup and perform push deploy
- [`step_rcmdcheck()`](https://docs.ropensci.org/tic/dev/reference/step_rcmdcheck.md)
  : Step: Check a package
- [`step_run_code()`](https://docs.ropensci.org/tic/dev/reference/step_run_code.md)
  : Step: Run arbitrary R code
- [`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md)
  : Step: Print the current Session Info
- [`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
  : Step: Setup push deploy
- [`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md)
  : Step: Setup SSH
- [`step_test_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_test_ssh.md)
  : Step: Test SSH connection
- [`step_write_text_file()`](https://docs.ropensci.org/tic/dev/reference/step_write_text_file.md)
  : Step: Write a text file
- [`TicStep`](https://docs.ropensci.org/tic/dev/reference/TicStep.md) :
  The base class for all steps

## Stages

- [`before_install()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`install()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`after_install()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`before_script()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`script()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`after_success()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`after_failure()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`before_deploy()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`deploy()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`after_deploy()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  [`after_script()`](https://docs.ropensci.org/tic/dev/reference/stages.md)
  : Predefined stages

## CI Metadata

- [`ci_get_branch()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_is_tag()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_get_slug()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_get_build_number()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_get_build_url()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_get_commit()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_get_env()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_is_env()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_has_env()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_can_push()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_is_interactive()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_cat_with_color()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_on_circle()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci_on_ghactions()`](https://docs.ropensci.org/tic/dev/reference/ci.md)
  [`ci()`](https://docs.ropensci.org/tic/dev/reference/ci.md) : The
  current CI environment

## Executing locally

- [`run_all_stages()`](https://docs.ropensci.org/tic/dev/reference/run_all_stages.md)
  : Emulate a CI run locally
- [`prepare_all_stages()`](https://docs.ropensci.org/tic/dev/reference/prepare_all_stages.md)
  : Prepare all stages
- [`run_stage()`](https://docs.ropensci.org/tic/dev/reference/run_stage.md)
  : Run a stage

## Setup

- [`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)
  : Initialize CI testing using tic
- [`use_tic_r()`](https://docs.ropensci.org/tic/dev/reference/use_tic_r.md)
  : Add a tic.R file to the repo
- [`use_tic_badge()`](https://docs.ropensci.org/tic/dev/reference/use_tic_badge.md)
  : Add a CI Status Badge to README files

## Deployment

- [`use_ghactions_deploy()`](https://docs.ropensci.org/tic/dev/reference/use_ghactions_deploy.md)
  **\[experimental\]** : Setup deployment for GitHub Actions
- [`gha_add_secret()`](https://docs.ropensci.org/tic/dev/reference/gha_add_secret.md)
  : Add a GitHub Actions secret to a repository

## Serialization

- [`base64serialize()`](https://docs.ropensci.org/tic/dev/reference/base64serialize.md)
  [`base64unserialize()`](https://docs.ropensci.org/tic/dev/reference/base64serialize.md)
  : Helpers for converting R objects to strings and back

## CRAN repository functions

- [`repo_default()`](https://docs.ropensci.org/tic/dev/reference/repo.md)
  [`repo_cloud()`](https://docs.ropensci.org/tic/dev/reference/repo.md)
  [`repo_cran()`](https://docs.ropensci.org/tic/dev/reference/repo.md)
  [`repo_bioc()`](https://docs.ropensci.org/tic/dev/reference/repo.md) :
  Shortcuts for accessing CRAN-like repositories

## Helpers

- [`auth_github()`](https://docs.ropensci.org/tic/dev/reference/github_helpers.md)
  [`get_owner()`](https://docs.ropensci.org/tic/dev/reference/github_helpers.md)
  [`get_user()`](https://docs.ropensci.org/tic/dev/reference/github_helpers.md)
  [`get_repo()`](https://docs.ropensci.org/tic/dev/reference/github_helpers.md)
  [`get_repo_slug()`](https://docs.ropensci.org/tic/dev/reference/github_helpers.md)
  : Github API helpers
- [`github_add_key()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md)
  [`check_admin_repo()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md)
  [`get_role_in_repo()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md)
  [`get_public_key()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md)
  [`encode_private_key()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md)
  [`check_private_key_name()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md)
  : SSH key helpers
- [`github_repo()`](https://docs.ropensci.org/tic/dev/reference/github_info.md)
  [`github_info()`](https://docs.ropensci.org/tic/dev/reference/github_info.md)
  [`uses_github()`](https://docs.ropensci.org/tic/dev/reference/github_info.md)
  : Github information

## Deprecated

- [`add_package_checks()`](https://docs.ropensci.org/tic/dev/reference/Deprecated.md)
  : Deprecated functions
