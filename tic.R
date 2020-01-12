get_stage("install") %>%
  add_step(step_install_github("ropensci/rotemplate"))

do_package_checks()

if (ci_has_env("BUILD_PKGDOWN")) {
  # just for internal testing, do not copy this four yourself!
  # use `use_tic()` or `use_*_yml()` to set up tic for your own project
  do_pkgdown(travis_private_key_name = "Custom ssh key name")
}
