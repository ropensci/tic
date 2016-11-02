#' @export
install_deploy_dependencies <- function(task_code = get_task_code()) {

    parsed <- parse_task_code(task_code)

    packages <- unlist(lapply(parsed, attr, "packages"))

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
