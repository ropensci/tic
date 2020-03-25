# installs dependencies, runs R CMD check, runs covr::codecov()
do_package_checks()

# creates pkgdown site and pushes to gh-pages branch
# only for runners with the "BUILD_PKGDOWN" env var set
if (ci_has_env("BUILD_PKGDOWN")) {
  do_pkgdown()
}
