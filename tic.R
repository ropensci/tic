get_stage("install") %>%
  add_step(step_install_github("ropensci/rotemplate"))

do_package_check()

if (ci_has_env("BUILD_PKGDOWN")) {
  do_pkgdown()
}
