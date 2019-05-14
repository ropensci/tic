do_package_checks()

if (ci_is_travis()) {
  do_pkgdown()
}
