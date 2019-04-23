add_package_checks(error_on = if (getRversion() >= "3.2") "warning" else "error")

do_pkgdown()
