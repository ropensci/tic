#' @export
step <- function(step, ..., on_branch = NULL, on_env = NULL) {
  structure(
    list(
      step = step,
      args = list(...),
      on_branch = on_branch,
      on_env = on_env
    ),
    class = "tic_step"
  )
}

match_branch <- function(on_branch) {
  branch <- ci()$get_branch()

  match_regex <- "^/(.*)/$"
  if (is.null(on_branch)) {
    TRUE
  } else if (length(on_branch) == 1 && grepl(match_regex, on_branch)) {
    grepl(gsub(match_regex, "\\1", on_branch), branch)
  } else {
    any(on_branch %in% branch)
  }
}
