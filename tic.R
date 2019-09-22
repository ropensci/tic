get_stage("install") %>%
  add_step(step_install_github("ropensci/rotemplate"))

if (ci_on_travis()) {
  do_package_checks(error_on = if (getRversion() >= "3.2") "warning" else "error")
} else if (ci_on_appveyor()) {
  do_package_checks(args = c("--no-tests", "--no-vignettes"),
                    error_on = if (getRversion() >= "3.2") "warning" else "error")
}

if (ci_has_env("BUILD_PKGDOWN")) {
  do_pkgdown()
}
