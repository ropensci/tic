get_head_commit <- function(branch) {
  if (git2r::is_commit(branch)) {
    return(branch)
  }
  git2r::lookup(git2r_attrib(branch, "repo"), git2r::branch_target(branch))
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) { # nolint
  vapply(X = X, FUN = FUN, FUN.VALUE = logical(1L), ..., USE.NAMES = USE.NAMES)
}

stopc <- function(...) {
  stop(..., call. = FALSE, domain = NA)
}

warningc <- function(...) {
  warning(..., call. = FALSE, domain = NA)
}

warning_once <- memoise::memoise(warningc)

`%||%` <- function(o1, o2) { # nolint
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

project_name <- function(base_path = usethis::proj_get()) {
  if (is_package(base_path)) {
    project_data(base_path)$Package
  } else {
    project_data(base_path)$Project
  }
}

project_data <- function(base_path = usethis::proj_get()) {
  if (is_package(base_path)) {
    data <- package_data(base_path)
  } else {
    data <- list(Project = file.path(base_path))
  }
  data
}

is_package <- function(base_path = usethis::proj_get()) {
  res <- tryCatch(
    rprojroot::find_package_root_file(path = base_path),
    error = function(e) NULL
  )
  !is.null(res)
}

package_data <- function(base_path = usethis::proj_get()) {
  desc <- desc::description$new(base_path)
  as.list(desc$get(desc$fields()))
}

yesno <- function(...) {
  yeses <- c(
    "Yes", "Definitely", "For sure", "Yup", "Yeah", "Of course",
    "Absolutely"
  )
  nos <- c("No way", "Not yet", "I forget", "No", "Nope", "Uhhhh... Maybe?")

  cat(paste0(..., collapse = ""))
  qs <- c(sample(yeses, 1), sample(nos, 2))
  rand <- sample(length(qs))

  menu(qs[rand]) != which(rand == 1)
}

check_travis_pkg <- function() {
  if (!is_installed("travis")) {
    cli::cat_rule(col = "red")
    stopc(
      "`use_tic()` needs the `travis` package. Please ",
      'install it using `remotes::install_github("ropenscilabs/travis")`.'
    )
  }
}

check_circle_pkg <- function() {
  if (!is_installed("circle")) {
    cli::cat_rule(col = "red")
    stopc(
      "`use_tic()` needs the `circle` package. Please ",
      'install it using `remotes::install_github("pat-s/circle")`.'
    )
  }
}

check_usethis_pkg <- function() {
  if (!is_installed("usethis")) {
    cli::cat_rule(col = "red")
    stopc(
      "`use_tic()` needs the `usethis` package, ",
      'please install using `install.packages("usethis")`.'
    )
  }
}

check_openssl_pkg <- function() {
  cli::cat_rule(col = "red")
  stopc(
    "`use_tic()` needs the `openssl` package to set up deployment, ",
    'please install using install.packages("openssl").'
  )
}

detect_repo_type <- function() {
  if (file.exists("_bookdown.yml")) {
    return("bookdown")
  }
  if (file.exists("_site.yml")) {
    return("site")
  }
  if (file.exists("config.toml")) {
    return("blogdown")
  }
  if (file.exists("DESCRIPTION")) {
    return("package")
  }

  if (!interactive()) {
    return("unknown")
  }

  cli::cat_bullet(
    "Unable to guess the repo type. ",
    "Please choose the desired one from the menu.",
    bullet = "warning"
  )

  choices <- c(
    blogdown = "Blogdown", bookdown = "Bookdown",
    package = "Package", website = "Website",
    unknown = "Other"
  )
  chosen <- utils::menu(choices)
  if (chosen == 0) {
    stopc("Aborted.")
  } else {
    names(choices)[[chosen]]
  }
}

use_github_interactive <- function() {
  if (!interactive()) {
    return()
  }
  if (travis::uses_github()) {
    return()
  }

  if (!yesno("Create GitHub repo and push code?")) {
    return()
  }

  message("Creating GitHub repository")
  usethis::use_github()
}

get_install_tic_code <- function() {
  if (getNamespaceVersion("tic") >= "1.0") {
    # We are on CRAN!
    "remotes::install_cran('tic', upgrade = 'always')"
  } else {
    "remotes::install_github('ropenscilabs/tic', upgrade = 'always')"
  }
}

double_quotes <- function(x) {
  gsub("'", '"', x, fixed = TRUE)
}
