get_stage("before_install") %>%
  add_step(step_run_code(update.packages(ask = FALSE)))

get_stage("install") %>%
  add_step(step_run_code(remotes::install_deps(dependencies = TRUE)))

get_stage("script") %>%
  add_step(step_rcmdcheck())

get_stage("after_success") %>%
  add_step(step_run_code(covr::codecov(quiet = FALSE)))

get_stage("before_deploy") %>%
  add_step(step_setup_ssh())

if (ci()$is_tag() && Sys.getenv("BUILD_PKGDOWN") != "") {
  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `ci()$is_tag()`: Only for tags, not for branches
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("deploy") %>%
    add_step(step_build_pkgdown()) %>%
    add_step(step_push_deploy())
}
