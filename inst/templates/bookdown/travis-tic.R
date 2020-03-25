if (ci_on_travis() && ci_has_env("BUILD_BOOKDOWN")) {
  do_bookdown(input = "")
}
