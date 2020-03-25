if (ci_on_ghactions() && ci_is_env("BUILD_PKGDOWN", "true")) {
  do_pkgdown()
}
