if (ci_on_ghactions() && ci_has_env("BUILD_BOOKDOWN")) {
  do_bookdown(input = "")
}
