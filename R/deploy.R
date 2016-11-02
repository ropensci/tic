#' @export
deploy <- function(tasks = get_tasks()) {

  # get system environment variables
  env <- Sys.getenv(c("TRAVIS_BRANCH", "TRAVIS_EVENT_TYPE", "TRAVIS_REPO_SLUG",
                      "RCHECK_DIR", "TRAVIS_BUILD_DIR", "TRAVIS_COMMIT",
                      "encryption_key", "encryption_iv"),
                    names = TRUE)

  # only run on pushes
  # specify which branches to push in the deploy/on/branch section in .travis.yml
  # see also https://docs.travis-ci.com/user/deployment/script/
  if (env[["TRAVIS_EVENT_TYPE"]] == "push") {
    for (task in tasks) {
      eval(parse(text = task))
    }
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
