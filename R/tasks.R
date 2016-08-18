#' Use travis vignettes
#'
#' @param pkg package description, can be path or package name. See
#'   \code{\link{as.package}} for more information.
#' @param author_email Email that will be used for commits on your behalf.
#'
#' @export
use_travis_vignettes <- function(pkg = ".", author_email = NULL) {
  pkg <- devtools::as.package(pkg)
  travis_path <- file.path(pkg$path, ".travis.yml")
  key_file <- ".deploy_key"
  key_path <- file.path(pkg$path, key_file)
  enc_key_file <- paste0(key_file, ".enc")
  enc_key_path <- file.path(pkg$path, enc_key_file)
  script_file <- ".push_gh_pages.sh"
  script_path <- file.path(pkg$path, script_file)

  if (is.null(author_email)) {
    author_email <- devtools:::maintainer(pkg)$email
  }

  if (!file.exists(travis_path)) devtools::use_travis(pkg)
  travis_yml <- yaml::yaml.load_file(travis_path)

  # authenticate on github and travis and set up keys/vars
  gh <- github_info(pkg$path)
  enc_id <- setup_keys(gh$owner$login, gh$name, key_path, enc_key_path)

  # get push script to be run on travis
  script_src <- system.file("script", "push_gh_pages.sh",
                            package = "travis", mustWork = TRUE)
  file.copy(script_src, script_path)

  # add new files to .Rbuildignore
  devtools::use_build_ignore(enc_key_file, pkg = pkg)
  devtools::use_build_ignore(script_file, pkg = pkg)

  # update .travis.yml
  new_travis_yml <- edit_travis_yml(travis_yml, author_email, enc_id, script_file)
  writeLines(yaml::as.yaml(new_travis_yml), travis_path)

  # commit changes to git
  r <- git2r::repository(pkg$path)
  st <- vapply(git2r::status(r), length, integer(1))
  if (any(st != 0)) {
    git2r::add(r, ".Rbuildignore")
    git2r::add(r, ".travis.yml")
    git2r::add(r, script_file)
    git2r::add(r, enc_key_file)
    #git2r::commit(r, "set up travis pushing vignettes to gh-pages")
  }

}
