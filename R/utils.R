get_head_commit <- function(branch) {
  if (git2r::is_commit(branch)) {
    return(branch)
  }
  git2r::lookup(branch@repo, git2r::branch_target(branch))
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X = X, FUN = FUN, FUN.VALUE = logical(1L), ..., USE.NAMES = USE.NAMES)
}

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X = X, FUN = FUN, FUN.VALUE = character(1L), ..., USE.NAMES = USE.NAMES)
}

stopc <- function(...) {
  stop(..., call. = FALSE, domain = NA)
}

warningc <- function(...) {
  warning(..., call. = FALSE, domain = NA)
}

warning_once <- memoise::memoise(warningc)

`%||%` <- function(o1, o2) {
  if (is.null(o1)) o2 else o1
}

cat_line <- function(...) {
  cat(..., "\n", sep = "")
}

verify_install <- function(...) {
  pkg_names <- c(...)
  lapply(pkg_names, verify_install_one)
}

verify_install_one <- function(pkg_name) {
  if (!package_installed(pkg_name)) {
    utils::install.packages(pkg_name)
    if (!package_installed(pkg_name)) {
      stopc("Error installing package ", pkg_name, " or one of its dependencies.")
    }
  }
}

package_installed <- function(pkg_name) {
  path <- system.file("DESCRIPTION", package = pkg_name)
  file.exists(path)
}

with_traceback <- function(...) {
  withr::with_options(
    list(
      error = expression({traceback(1); if (!interactive()) q(status = 1)}),
      deparse.max.lines = 2
    ),
    ...
  )
}

format_traceback <- function() {
  x <- .traceback(rev(sys.calls()))
  paste0(format(seq_along(x)), ". ", x, collapse = "\n")
}
