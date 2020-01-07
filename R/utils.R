get_head_commit <- function(branch) {
  if (git2r::is_commit(branch)) {
    return(branch)
  }
  git2r::lookup(git2r_attrib(branch, "repo"), git2r::branch_target(branch))
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X = X, FUN = FUN, FUN.VALUE = logical(1L), ..., USE.NAMES = USE.NAMES)
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

get_deps_from_code <- function(call) {
  if (!is.call(call)) {
    return(character())
  }

  if (identical(call[[1]], quote(`::`))) {
    as.character(call[[2]])
  }
  else {
    deps <- lapply(as.list(call), get_deps_from_code)
    as.character(unlist(deps))
  }
}

format_traceback <- function(top = NULL, bottom = parent.frame()) {
  paste(format(trace_back(top, bottom)), collapse = "\n")
}

tempfile_slash <- function(pattern = "file", tmpdir = tempdir(), fileext = "") {
  path <- tempfile(pattern, tmpdir, fileext)
  normalizePath(path, winslash = "/", mustWork = FALSE)
}

# borrowed from {usethis} ------------------------------------------------------

check_package_name <- function(name) {
  if (!valid_package_name(name)) {
    cli::cli_par()
    cli::cli_text("{.pkg name} is not a valid package name. It should:")
    cli::cli_li("Contain only ASCII letters, numbers, and '.'")
    cli::cli_li("Have at least two characters")
    cli::cli_li("Start with a letter")
    cli::cli_li("Not end with '.'")
    cli::cli_end()
  }
}

valid_package_name <- function(x) {
  grepl("^[a-zA-Z][a-zA-Z0-9.]+$", x) && !grepl("\\.$", x)
}

project_name <- function(base_path = proj_get()) {
  if (is_package(base_path)) {
    project_data(base_path)$Package
  } else {
    project_data(base_path)$Project
  }
}

project_data <- function(base_path = proj_get()) {
  if (is_package(base_path)) {
    data <- package_data(base_path)
  } else {
    data <- list(Project = path_file(base_path))
  }
  data
}

is_package <- function(base_path = proj_get()) {
  res <- tryCatch(
    rprojroot::find_package_root_file(path = base_path),
    error = function(e) NULL
  )
  !is.null(res)
}

package_data <- function(base_path = proj_get()) {
  desc <- desc::description$new(base_path)
  as.list(desc$get(desc$fields()))
}
