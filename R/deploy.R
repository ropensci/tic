#' @export
install_deploy_dependencies <- function(task_code = get_task_code()) {

  parsed <- parse_task_code(task_code)

  packages <- get_packages_from_parsed(parsed)

  if (length(packages) == 0L) {
    return(invisible())
  }

  message("Installing deploy dependencies: ", paste(packages, collapse = ", "))
  install.packages(packages)

}

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

get_packages_from_parsed <- function(parsed) {
  unlist(lapply(parsed, get_packages_from_parsed_one))
}

get_packages_from_parsed_one <- function(parsed_one) {
  task <- as.list(parsed_one)[[1L]]

  if (is.call(task)) {
    task_call_components <- as.list(task)
    if (task_call_components[[1L]] == "::") {
      return(as.character(task_call_components[[2L]]))
    }
  }

  task_object <- eval(task)
  attr(task_object, "packages")
}
