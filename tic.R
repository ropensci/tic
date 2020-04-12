do_package_checks()

if (ci_on_ghactions() && ci_is_env("BUILD_PKGDOWN", "true")) {
  get_stage("before_deploy") %>%
    add_step(step_install_github("ropensci/rotemplate"))
  do_pkgdown()
}
