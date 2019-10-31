#' @title Use CI YAML templates
#' @description Installs YAML templates for various CI providers.
#'
#' @param type `[character]`\cr
#'   Which template to use. The string should be given following the logic
#'   `<provider>-<platform>-<action>`. See details for more.
#'
#' @section Type:
#' `tic` supports a variety of different YAML templates which follow the
#'  `<provider>-<platform>-<action>` pattern. The first one is mandatory, the
#'  others are optional.
#'
#'  * Possible values for `<provider>` are `travis`, and `circle`
#'  * Possible values for `<platform>` are `linux`, and `macos`, `windows`.
#'  * Possible values for `<action>` are `matrix` and `deploy`.
#'
#'  Not every combinations is supported on all CI systems.
#'  For example, for `use_appveyor_yaml()` only `windows` and `windows-matrix` are valid.
#'
#' @name yaml-templates
#' @export
use_travis_yml <- function(type) {
  if (type == "linux") {
    template = "travis-linux.yml"
  } else if (type == "linux-matrix") {
    template = "travis-linux-matrix.yml"
  } else if (type == "linux-deploy") {
    template = "travis-linux-deploy.yml"
  } else if (type == "linux-deploy-matrix") {
    template = "travis-linux-deploy-matrix.yml"
  } else if (type == "macos") {
    template = "travis-macos.yml"
  } else if (type == "macos-matrix") {
    template = "travis-macos-matrix.yml"
  } else if (type == "macos-deploy") {
    template = "travis-macos-deploy.yml"
  } else if (type == "macos-deploy-matrix") {
    template = "travis-macos-deploy-matrix.yml"
  }
  use_tic_template(
    template,
    save_as = ".travis.yml",
    data = list(install_tic = double_quotes(get_install_tic_code()))
  )
}

#' @rdname yaml-templates
#' @export
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

#' @rdname yaml-templates
#' @export
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
  dir.create(".circleci")
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
