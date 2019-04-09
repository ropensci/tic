do_package_checks(error_on = if (getRversion() >= "3.2") "warning" else "error")

get_stage("deploy") %>%
  add_step(step_build_pkgdown())

if (ci_has_env("BUILD_PKGDOWN") && !ci_is_env("TRAVIS_PULL_REQUEST", "cron")) {
  get_stage("before_deploy") %>%
    add_step(step_setup_ssh())

  # pkgdown documentation can be built optionally. Other example criteria:
  # - `inherits(ci(), "TravisCI")`: Only for Travis CI
  # - `Sys.getenv("BUILD_PKGDOWN") != ""`: If the env var "BUILD_PKGDOWN" is set
  # - `Sys.getenv("TRAVIS_EVENT_TYPE") == "cron"`: Only for Travis cron jobs
  get_stage("deploy") %>%
    add_step(step_push_deploy())
}
