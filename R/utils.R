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

yesno <- function(...) {
  yeses <- c("Yes", "Definitely", "For sure", "Yup", "Yeah", "Of course", "Absolutely")
  nos <- c("No way", "Not yet", "I forget", "No", "Nope", "Uhhhh... Maybe?")

  cat(paste0(..., collapse = ""))
  qs <- c(sample(yeses, 1), sample(nos, 2))
  rand <- sample(length(qs))

  menu(qs[rand]) != which(rand == 1)
}

check_travis_pkg = function() {
  if (!is_installed("travis")) {
    cli::cat_rule(col = "red")
    stopc(
      "`use_tic()` needs the `travis` package. Please ",
      'install it using `remotes::install_github("ropenscilabs/travis")`.'
    )
  }
}

check_circle_pkg = function() {
  if (!is_installed("circle")) {
    cli::cat_rule(col = "red")
    stopc(
      "`use_tic()` needs the `circle` package. Please ",
      'install it using `remotes::install_github("pat-s/circle")`.'
    )
  }
}

check_usethis_pkg = function() {
  if (!is_installed("usethis")) {
    cli::cat_rule(col = "red")
    stopc(
      "`use_tic()` needs the `usethis` package, ",
      'please install using `install.packages("usethis")`.'
    )
  }
}

check_openssl_pkg = function() {
  cli::cat_rule(col = "red")
  stopc(
    "`use_tic()` needs the `openssl` package to set up deployment, ",
    'please install using install.packages("openssl").'
  )
}
