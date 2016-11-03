run_setup_repo <- function() {

  task_install_ssh_keys()

  env <- get("env", parent.frame())

  # clone repo
  repo_url <- sprintf("git@github.com:%s.git", env[["TRAVIS_REPO_SLUG"]])
  local_path <- file.path("/tmp", env[["TRAVIS_REPO_SLUG"]])
  if (dir.exists(local_path)) unlink(local_path, recursive = TRUE)
  system(sprintf("git clone --depth=50 %s %s", repo_url, local_path))
  repo <- git2r::repository(local_path)
  # repo <- git2r::clone(repo_url, local_path = env[["TRAVIS_REPO_SLUG"]],
  #                      branch = "master")
  setwd(local_path)

  # configure repo
  # TODO: use TRAVIS_COMMIT instead of latest commit
  author <- git2r::commits(repo)[[1]]@author
  git2r::config(repo, user.name = author@name, user.email = author@email)

}

run_push_vignettes <- function() {

  env <- Sys.getenv()

  local_path <- file.path("/tmp", env[["TRAVIS_REPO_SLUG"]])
  repo <- git2r::repository(local_path)
  setwd(local_path)

  #switch to gh-pages branch
  #git2r::checkout(repo, branch = "gh-pages", create = TRUE)
  system("git checkout --orphan gh-pages")
  system("git rm -rf .")

  # copy over rendered vignettes
  pkg_name <- unlist(strsplit(env[["RCHECK_DIR"]], ".Rcheck"))
  src_dir <- file.path(env[["TRAVIS_BUILD_DIR"]], env[["RCHECK_DIR"]],
                       "00_pkg_src", pkg_name, "inst", "doc")
  # src_dir <- sprintf("../../%s/00_pkg_src/%s/inst/doc", env[["RCHECK_DIR"]],
  #                    pkg_name)
  html_files <- list.files(src_dir, pattern = "*.html", full.names = TRUE)
  file.copy(html_files, ".", overwrite = TRUE)

  # commit and push
  git2r::add(repo, "*.html")
  st <- vapply(git2r::status(repo), length, integer(1))
  if (st[["staged"]] != 0) {
    git2r::commit(repo, message = "deploy to github pages")
    system("git push -u origin gh-pages")
    #git2r::push(repo, "origin", "gh-pages", credentials = cred)
  }

}
