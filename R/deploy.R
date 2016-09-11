#' @export
deploy <- function(tasks) {

  # get system environment variables
  env <- Sys.getenv(c("TRAVIS_BRANCH", "TRAVIS_EVENT_TYPE", "TRAVIS_REPO_SLUG",
                      "RCHECK_DIR", "TRAVIS_BUILD_DIR", "TRAVIS_COMMIT",
                      "encryption_key", "encryption_iv"),
                    names = TRUE)

  # only run on pushes to master
  if (env[["TRAVIS_BRANCH"]] == "master" && env[["TRAVIS_EVENT_TYPE"]] == "push") {
    for (task in tasks) {
      eval(parse(text = task))
    }
  }

}
