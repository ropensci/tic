use_travis_yml <- function(type) {
  if (type == "linux") {
    template = "dot-travis-linux.yml"
  } else if (type == "linux-matrix") {
    template = "dot-travis-linux-matrix.yml"
  } else if (type == "linux-deploy") {
    template = "dot-travis-linux-deploy.yml"
  } else if (type == "linux-deploy-matrix") {
    template = "dot-travis-linux-deploy-matrix.yml"
  } else if (type == "macos") {
    template = "dot-travis-macos.yml"
  } else if (type == "macos-matrix") {
    template = "dot-travis-macos-matrix.yml"
  } else if (type == "macos-deploy") {
    template = "dot-travis-macos-deploy.yml"
  } else if (type == "macos-deploy-matrix") {
    template = "dot-travis-macos-deploy-matrix.yml"
  }
  use_tic_template(
    template,
    save_as = ".travis.yml",
    data = list(install_tic = double_quotes(get_install_tic_code()))
  )
}

use_appveyor_yml <- function(type) {
  if (type == "windows") {
    template = "appveyor.yml"
  } else if (type == "windows-matrix") {
    template = "appveyor-matrix.yml"
  }
  use_tic_template(
    template,
    save_as = "appveyor.yml",
    data = list(install_tic = get_install_tic_code())
  )
}

use_circle_yml <- function(type) {
  if (type == "linux") {
    template = "circle.yml"
  } else if (type == "linux-matrix") {
    template = "circle-matrix.yml"
  } else if (type == "linux-deploy") {
    template = "circle-deploy.yml"
  } else if (type == "linux-deploy-matrix") {
    template = "circle-deploy-matrix.yml"
  }
  use_tic_template(
    template,
    save_as = ".circleci/config.yml",
    data = list(install_tic = get_install_tic_code())
  )

  # FIXME: upstream issue in _whisker_ pkg which cannot handle curly braces
  # https://github.com/edwindj/whisker/issues/20
  tx  <- readLines(sprintf("%s/.circleci/config.yml", usethis::proj_path()))
  tx2  <- gsub(pattern = "checksum", replacement = "{{ checksum", x = tx)
  tx2  <- gsub(pattern = '_tmp_file"', replacement = '_tmp_file" }}', x = tx2)
  writeLines(tx2, con=sprintf("%s/.circleci/config.yml", usethis::proj_path()))
}

use_tic_template <- function(template, save_as = template, open = FALSE,
                             ignore = TRUE, data = NULL) {
  usethis::use_template(
    template, save_as,
    package = "tic", open = open, ignore = ignore, data = data
  )
}
