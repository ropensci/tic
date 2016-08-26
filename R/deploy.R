#' @export
deploy <- function() {

  # get system environment variables
  env <- Sys.getenv(c("TRAVIS_BRANCH", "TRAVIS_EVENT_TYPE", "TRAVIS_REPO_SLUG",
                      "RCHECK_DIR", "encryption_key", "encryption_iv"),
                    names = TRUE)

  print(env)
  print(getwd())

  # only run on pushes to master
  if (env[["TRAVIS_BRANCH"]] == "master" && env[["TRAVIS_EVENT_TYPE"]] == "push") {

    # clone repo
    # TODO: is cloning repo into already cloned repo bad?
    repo_url <- sprintf("git@github.com:%s.git", env[["TRAVIS_REPO_SLUG"]])
    local_path <- env[["TRAVIS_REPO_SLUG"]]
    system(sprintf("git clone --depth=50 %s %s", repo_url, local_path),
           ignore.stdout = TRUE, ignore.stderr = TRUE)
    repo <- git2r::repository(local_path)
    # repo <- git2r::clone(repo_url, local_path = env[["TRAVIS_REPO_SLUG"]],
    #                      branch = "master")
    setwd(local_path)

    # decrypt deploy key
    deploy_key <- openssl::aes_cbc_decrypt(
      ".deploy_key.enc", openssl::base64_decode(env[["encryption_key"]]),
      openssl::base64_decode(env[["encryption_iv"]])
    )
    deploy_key_path <- ".deploy_key"
    writeBin(deploy_key, deploy_key_path)
    #cred <- git2r::cred_ssh_key(".deploy_key.pub", ".deploy_key")
    Sys.chmod(deploy_key_path, "600")
    system(sprintf("ssh-agent sh -c 'ssh-add %s'", deploy_key_path))

    # configure repo and switch to gh-pages branch
    author <- git2r::commits(repo)[[1]]@author
    git2r::config(repo, user.name = author@name, user.email = author@email)
    git2r::checkout(repo, branch = "gh-pages", create = TRUE)

    # copy over rendered vignettes
    pkg_name <- unlist(strsplit(env[["RCHECK_DIR"]], ".Rcheck"))
    src_dir <- sprintf("../../%s/00_pkg_src/%s/inst/doc", env[["RCHECK_DIR"]],
                       pkg_name)
    html_files <- list.files(src_dir, pattern = "*.html")
    file.copy(unlist(lapply(html_files,
                            function(file) file.path(src_dir, file))),
              ".", overwrite = TRUE)

    # commit and push
    git2r::add(repo, "*.html")
    st <- vapply(git2r::status(repo), length, integer(1))
    if (st[["staged"]] != 0) {
      system("git commit -m 'deploy to github pages'")
      #git2r::commit(repo, message = "deploy to github pages")
      system("git push -u origin gh-pages")
      #git2r::push(repo, "origin", "gh-pages", credentials = cred)
    }

    unlink(".deploy_key")

  }

}
