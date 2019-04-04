add_package_checks(error_on = if (getRversion() >= "3.2") "warning" else "error")

get_stage("deploy") %>%
  add_step(step_build_pkgdown())

do_pkgdown_site()
