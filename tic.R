if (ci_on_gh_actions() && ci_is_env("BUILD_PKGDOWN", "true")) {
  do_pkgdown()
}
