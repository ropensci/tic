#' @title Use CI YAML templates
#' @description Installs YAML templates for various CI providers.
#'
#' @param type `[character]`\cr
#'   Which template to use. The string should be given following the logic
#'   `<platform>-<action>`. See details for more.
#'
#' @section Type:
#' `tic` supports a variety of different YAML templates which follow the
#'  `<platform>-<action>` pattern. The first one is mandatory, the
#'  others are optional.
#'
#'  * Possible values for `<provider>` are `travis`, and `circle`
#'  * Possible values for `<platform>` are `linux`, and `macos`, `windows`.
#'  * Possible values for `<action>` are `matrix` and `deploy`.
#'
#'  Not every combinations is supported on all CI systems.
#'  For example, for `use_appveyor_yaml()` only `windows` and `windows-matrix` are valid.
#'
#'  Here is a list of all available combinations:
#'
#'  | Provider | Operating system | Deployment | multiple R versions | Call |
#'  | -------  | ---------------- | ---------- | ------------------- | ---- |
#'  |----------|------------------|------------|---------------------|---------------------------------------------------------|
#'  | Travis   | Linux            | no         | no                  | `use_travis_yml("linux")` |
#'  |          | Linux            | yes        | no                  | `use_travis_yml("linux-deploy")` |
#'  |          | Linux            | no         | yes                 | `use_travis_yml("linux-matrix")` |
#'  |          | Linux            | yes        | yes                 | `use_travis_yml("linux-deploy-matrix")` |
#'  |          | macOS            | no         | no                  | `use_travis_yml("macOS")` |
#'  |          | macOS            | yes        | no                  | `use_travis_yml("macos-deploy")` |
#'  |          | macOS            | no         | yes                 | `use_travis_yml("macos-matrix")` |
#'  |          | macOS            | yes        | yes                 | `use_travis_yml("macos-deploy-matrix")` |
#'  |----------|------------------|------------|---------------------|---------------------------------------------------------|
#'  | Circle   | Linux            | no         | no                  | `use_circle_yml("linux")` |
#'  |          | Linux            | yes        | no                  | `use_travis_yml("linux-deploy")` |
#'  |          | Linux            | no         | yes                 | `use_travis_yml("linux-matrix")` |'
#'  |          | Linux            | no         | yes                 | `use_travis_yml("linux-deploy-matrix")` |
#'  |----------|------------------|------------|---------------------|---------------------------------------------------------|
#'  | Appveyor | Windows          | no         | no                  | `use_appveyor_yml("windows")` |
#'  |          | Windows          | no         | yes                 | `use_travis_yml("windows-matrix")` |'
#'
#' @name yaml-templates
#' @aliases yaml-templates
#' @export
use_travis_yml <- function(type) {
  if (type == "linux") {
    os = readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-linux.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-no-deploy.yml", package = "tic"))
    template = c(os, meta, stages)
  } else if (type == "linux-matrix") {
    os = readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-linux.yml", package = "tic"))
    matrix = readLines(system.file("templates/travis-matrix.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-no-deploy.yml", package = "tic"))
    template = c(os, meta, matrix, stages)
  } else if (type == "linux-deploy") {
    os = readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-linux.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-deploy.yml", package = "tic"))
    template = c(os, meta, stages)
  } else if (type == "linux-deploy-matrix" || type == "linux-matrix-deploy") {
    os = readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-linux.yml", package = "tic"))
    matrix = readLines(system.file("templates/travis-matrix.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-deploy.yml", package = "tic"))
    template = c(os, meta, matrix, stages)
  } else if (type == "macos") {
    os = readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-macos.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-deploy.yml", package = "tic"))
    template = c(os, meta, stages)
  } else if (type == "macos-matrix") {
    os = readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-macos.yml", package = "tic"))
    matrix = readLines(system.file("templates/travis-matrix.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-no-deploy.yml", package = "tic"))
    template = c(os, meta, matrix, stages)
  } else if (type == "macos-deploy") {
    os = readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-macos.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-deploy.yml", package = "tic"))
    template = c(os, meta, stages)
  } else if (type == "macos-deploy-matrix" || type == "macos-matrix-deploy") {
    os = readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta = readLines(system.file("templates/travis-meta-macos.yml", package = "tic"))
    matrix = readLines(system.file("templates/travis-matrix.yml", package = "tic"))
    stages = readLines(system.file("templates/travis-deploy.yml", package = "tic"))
    template = c(os, meta, matrix, stages)
  }
  writeLines(template, ".travis.yml")
}

#' @rdname yaml-templates
#' @export
use_appveyor_yml <- function(type) {
  if (type == "windows") {
    template = "appveyor.yml"
  } else if (type == "windows-matrix") {
    template = "appveyor-matrix.yml"
  }
  writeLines(template, "appveyor.yml")
}

#' @rdname yaml-templates
#' @export
use_circle_yml <- function(type) {
  if (type == "linux") {
    template = readLines(system.file("templates/circle.yml", package = "tic"))
  } else if (type == "linux-matrix") {
    template = readLines(system.file("templates/circle-matrix.yml", package = "tic"))
  } else if (type == "linux-deploy") {
    template = readLines(system.file("templates/circle-deploy.yml", package = "tic"))
  } else if (type == "linux-deploy-matrix" || type == "linux-matrix-deploy") {
    template = readLines(system.file("templates/circle-deploy-matrix.yml", package = "tic"))
  }
  dir.create(".circleci", showWarnings = FALSE)
  writeLines(template, con = ".circleci/config.yml")
}

use_tic_template <- function(template, save_as = template, open = FALSE,
                             ignore = TRUE, data = NULL) {
  usethis::use_template(
    template, save_as,
    package = "tic", open = open, ignore = ignore, data = data
  )
}
