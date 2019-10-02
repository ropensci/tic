# This code can only run as part of a CI run
# nocov start

verify_install <- function(...) {
  pkg_names <- c(...)
  lapply(pkg_names, verify_install_one)
  lapply(pkg_names, verify_update_one)
}

verify_install_one <- function(pkg_name) {
  if (!package_installed(pkg_name)) {
    utils::install.packages(pkg_name)
    if (!package_installed(pkg_name)) {
      stopc(
        "Error installing package ", pkg_name, " or one of its dependencies."
      )
    }
  }
}

verify_update_one <- function(pkg_name) {
  update.packages(pkg_name)
}

package_installed <- function(pkg_name) {
  path <- system.file("DESCRIPTION", package = pkg_name)
  file.exists(path)
}

# This code can only run as part of a CI run
# nocov end
