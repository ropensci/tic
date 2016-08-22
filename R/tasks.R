#' Use travis vignettes
#'
#' @param pkg package description, can be path or package name. See
#'   \code{\link{as.package}} for more information.
#'
#' @export
use_travis_vignettes <- function(pkg = ".") {
  pkg <- devtools::as.package(pkg)
  travis_path <- file.path(pkg$path, ".travis.yml")
  key_file <- ".deploy_key"
  key_path <- file.path(pkg$path, key_file)
  pub_key_file <- paste0(key_file, ".pub")
  pub_key_path <- file.path(pkg$path, pub_key_file)
  enc_key_file <- paste0(key_file, ".enc")
  enc_key_path <- file.path(pkg$path, enc_key_file)

  if (!file.exists(travis_path)) devtools::use_travis(pkg)
  travis_yml <- yaml::yaml.load_file(travis_path)

  # authenticate on github and travis and set up keys/vars
  gh <- github_info(pkg$path)
  setup_keys(gh$owner$login, gh$name, key_path, pub_key_path, enc_key_path)
  devtools::use_build_ignore(pub_key_file, pkg = pkg)
  devtools::use_build_ignore(enc_key_file, pkg = pkg)

  # update .travis.yml
  new_travis_yml <- edit_travis_yml(travis_yml)
  writeLines(yaml::as.yaml(new_travis_yml), travis_path)

  # commit changes to git
  r <- git2r::repository(pkg$path)
  st <- vapply(git2r::status(r), length, integer(1))
  if (any(st != 0)) {
    git2r::add(r, ".Rbuildignore")
    git2r::add(r, ".travis.yml")
    git2r::add(r, pub_key_file)
    git2r::add(r, enc_key_file)
    git2r::commit(r, "set up travis pushing vignettes to gh-pages")
  }

}
