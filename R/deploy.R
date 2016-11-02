#' @export
deploy <- function(task_code = get_task_code()) {

  parsed <- parse_task_code(task_code)

  lapply(parsed, eval)

}

get_task_code <- function() {
  Sys.getenv("RTRAVIS_TASKS")
}

parse_task_code <- function(task_code) {
  parsed <- as.list(parse(text = task_code))
  names(parsed) <- vapply(parsed, deparse, nlines = 1L, character(1L))
  parsed
}
