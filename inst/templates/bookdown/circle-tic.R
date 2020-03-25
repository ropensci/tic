if (ci_on_circle() && ci_has_env("BUILD_BOOKDOWN")) {
  do_bookdown(input = "")
}
