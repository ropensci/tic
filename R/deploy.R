# env <- list("TRAVIS_BRANCH" = "master",
#             "TRAVIS_EVENT_TYPE" = "push",
#             "TRAVIS_REPO_SLUG" = "mikabr/testpackage",
#             "RCHECK_DIR" = "testpackage.Rcheck",
#             "encryption_key" = openssl::base64_encode(tempkey),
#             "encryption_iv" = openssl::base64_encode(iv))

#' @export
deploy <- function() {

  # get system environment variables
  env <- Sys.getenv(c("TRAVIS_BRANCH", "TRAVIS_EVENT_TYPE", "TRAVIS_REPO_SLUG",
                      "RCHECK_DIR", "encryption_key", "encryption_iv"),
                    names = TRUE)

  # only run on pushes to master
  if (env[["TRAVIS_BRANCH"]] == "master" && env[["TRAVIS_EVENT_TYPE"]] == "push") {

    # decrypt deploy key
    deploy_key <- openssl::aes_cbc_decrypt(
      ".deploy_key.enc", openssl::base64_decode(env[["encryption_key"]]),
      openssl::base64_decode(env[["encryption_iv"]])
    )
    writeBin(deploy_key, ".deploy_key")
    cred <- git2r::cred_ssh_key(".deploy_key.pub", ".deploy_key")

    # configure repo
    repo <- git2r::repository(".")
    author <- git2r::commits(repo)[[1]]@author
    git2r::config(repo, user.name = author@name, user.email = author@email)
    git2r::checkout(repo, branch = "gh-pages", create = TRUE)

    # copy over rendered vignettes
    pkg_name <- unlist(strsplit(env[["RCHECK_DIR"]], ".Rcheck"))
    src_dir <- sprintf("%s/00_pkg_src/%s/inst/doc", env[["RCHECK_DIR"]], pkg_name)
    html_files <- list.files(src_dir, pattern = "*.html")
    file.copy(unlist(lapply(html_files,
                            function(file) file.path(target_dir, file))),
              ".", overwrite = TRUE)
    unlink(env[["RCHECK_DIR"]], recursive = TRUE)

    # commit and push
    git2r::add(repo, "*.html")
    st <- vapply(git2r::status(repo), length, integer(1))
    if (st[["staged"]] != 0) {
      git2r::commit(repo, message = "deploy to github pages")
      git2r::push(repo, "origin", "gh-pages", credentials = cred)
    }

    unlink(".deploy_key")

  }

}
