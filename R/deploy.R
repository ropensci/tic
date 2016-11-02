#' @export
deploy <- function(tasks = get_tasks()) {

  for (task in tasks) {
    eval(parse(text = task))
  }

}

get_tasks <- function() {
  parse_task_env_value(Sys.getenv("RTRAVIS_TASKS"))
}

parse_task_env_value <- function(env_value) {
  env_value <- paste0(env_value, " ")
  split <- strsplit(env_value, "[)] +")[[1L]]
  if (length(split) == 1) {
    character()
  } else {
    paste0(split, ")")
  }
}
