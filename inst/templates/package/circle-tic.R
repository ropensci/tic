# installs dependencies, runs R CMD check, runs covr::codecov()
do_package_checks()

if (ci_on_circle()) {
  # creates pkgdown site and pushes to gh-pages branch
  do_pkgdown()
}
