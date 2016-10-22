#' @export
deploy <- function(tasks) {

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
