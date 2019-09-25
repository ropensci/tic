# This code can only run as part of a CI run
# nocov start

verify_install <- function(pkg_names, pkgType = NULL) {
  # set "type" to platform default
  if (is.null(pkgType)) {
    pkgType = update_type(pkgType)
  }
  #do.call(verify_install, args = list(pkg_names, pkgType))
  lapply(pkg_names, function(x) verify_install_one(x, pkgType = pkgType))
}

verify_install_one <- function(pkg_name, pkgType) {
  if (!package_installed(pkg_name)) {
    withr::with_options(
      c(pkgType = pkgType),
    utils::install.packages(pkg_name, INSTALL_opts = "--no-multiarch")
    )
    if (!package_installed(pkg_name)) {
      stopc(
        "Error installing package ", pkg_name, " or one of its dependencies."
      )
    }
  }
}

package_installed <- function(pkg_name) {
  path <- system.file("DESCRIPTION", package = pkg_name)
  file.exists(path)
}

# This code can only run as part of a CI run
# nocov end
