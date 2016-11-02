#' @importFrom R6 R6Class
#' @export
TravisTask <- R6Class(
  "TravisTask",
  cloneable = FALSE,

  public = list(
    run = function() {},
    prepare = function() {},
    check = function() TRUE
  )
)

HelloWorld <- R6Class(
  "HelloWorld", inherit = TravisTask,

  public = list(
    run = function() {
      print("Hello, world!")
    }
  )
)

#' @export
hello_world <- HelloWorld$new

InstallSSHKeys <- R6Class(
  "InstallSSHKeys", inherit = TravisTask,

  public = list(
    run = function() {
      message("Decrypting deploy key")
      deploy_key <- openssl::aes_cbc_decrypt(
        ".deploy_key.enc", openssl::base64_decode(Sys.getenv("encryption_key")),
        openssl::base64_decode(Sys.getenv("encryption_iv"))
      )
      deploy_key_path <- file.path("~/.ssh", "id_rsa")
      if (file.exists(deploy_key_path)) {
        stop("Not overwriting key", call. = FALSE)
      }
      message("Writing deploy key to ", deploy_key_path)
      writeBin(deploy_key, deploy_key_path)
      Sys.chmod(deploy_key_path, "600")
    },

    prepare = function() {
      if (!requireNamespace("openssl", quietly = TRUE))
        install.packages("openssl")
    },

    check = function() {
      # only run on pushes
      Sys.getenv("TRAVIS_EVENT_TYPE") == "push"
    }
  )
)

#' @export
install_ssh_keys <- InstallSSHKeys$new

RunCovr <- R6Class(
  "RunCovr", inherit = TravisTask,

  public = list(
    run = function() {
      covr::codecov()
    },

    prepare = function() {
      if (!requireNamespace("covr", quietly = TRUE))
        install.packages("covr")
    }
  )
)

#' @export
run_covr <- RunCovr$new

BuildPkgdown <- R6Class(
  "BuildPkgdown", inherit = TravisTask,

  public = list(
    initialize = function(branch = "master") {
      private$branch <- branch
    },

    run = function() {
      pkgdown::build_site()
    },

    prepare = function() {
      if (!requireNamespace("pkgdown", quietly = TRUE))
        devtools::install_github("hadley/pkgdown")
    },

    check = function() {
      Sys.getenv("TRAVIS_BRANCH") == private$branch
    }
  ),

  private = list(
    branch = NULL
  )
)

#' @export
build_pkgdown <- BuildPkgdown$new

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
