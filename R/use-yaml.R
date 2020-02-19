#' @title Use CI YAML templates
#' @description Installs YAML templates for various CI providers.
#'
#' @param type `[character]`\cr
#'   Which template to use. The string should be given following the logic
#'   `<platform>-<action>`. See details for more.
#'
#' @section pkgdown:
#'  If a setting including "deploy" is selected, {tic} by default also adds
#'  the environment var `BUILD_PKGDOWN=true`. This setting triggers a call
#'  to `pkgdown::build_site()` via the `do_pkgdown` macro in `tic.R`.
#'
#'  If a setting  includes "matrix" and builds on multiple R versions, the job
#'  building on R release is chosen to build the pkgdown site.
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
#'  For example, for `use_appveyor_yaml()` only `windows` and `windows-matrix`
#'  are valid.
#'
#'  **Github Actions** is special in the sense that it support all operating
#'  systems. Therefore, only the deploy/non/deploy switch is available and it
#'  does not follow the scheme described above.
#'
#'  Here is a list of all available combinations:
#'
#'  | Provider   | Operating system | Deployment | multiple R versions | Call                                                    |
#'  | -------    | ---------------- | ---------- | ------------------- | ------------------------------------------------------- |
#'  |----------  |------------------|------------|---------------------|---------------------------------------------------------|
#'  | Travis     | Linux            | no         | no                  | `use_travis_yml("linux")`                               |
#'  |            | Linux            | yes        | no                  | `use_travis_yml("linux-deploy")`                        |
#'  |            | Linux            | no         | yes                 | `use_travis_yml("linux-matrix")`                        |
#'  |            | Linux            | yes        | yes                 | `use_travis_yml("linux-deploy-matrix")`                 |
#'  |            | macOS            | no         | no                  | `use_travis_yml("macos")`                               |
#'  |            | macOS            | yes        | no                  | `use_travis_yml("macos-deploy")`                        |
#'  |            | macOS            | no         | yes                 | `use_travis_yml("macos-matrix")`                        |
#'  |            | macOS            | yes        | yes                 | `use_travis_yml("macos-deploy-matrix")`                 |
#'  |            | Linux + macOS    | no         | no                  | `use_travis_yml("linux-macos")`                         |
#'  |            | Linux + macOS    | yes        | no                  | `use_travis_yml("linux-macos-deploy")`                  |
#'  |            | Linux + macOS    | no         | yes                 | `use_travis_yml("linux-macos-matrix")`                  |
#'  |            | Linux + macOS    | yes        | yes                 | `use_travis_yml("linux-macos-deploy-matrix")`           |
#'  |----------  |------------------|------------|---------------------|---------------------------------------------------------|
#'  | Circle     | Linux            | no         | no                  | `use_circle_yml("linux")`                               |
#'  |            | Linux            | yes        | no                  | `use_travis_yml("linux-deploy")`                        |
#'  |            | Linux            | no         | yes                 | `use_travis_yml("linux-matrix")`                        |
#'  |            | Linux            | no         | yes                 | `use_travis_yml("linux-deploy-matrix")`                 |
#'  |----------  |------------------|------------|---------------------|---------------------------------------------------------|
#'  | Appveyor   | Windows          | no         | no                  | `use_appveyor_yml("windows")`                           |
#'  |            | Windows          | no         | yes                 | `use_travis_yml("windows-matrix")`                      |
#'  |----------  |------------------|------------|---------------------|---------------------------------------------------------|
#'  | GH Actions | All              | no         | yes                 | `use_ghactions_yml()`                              |
#'  |            | All              | no         | yes                 | `use_ghactions_yml(deploy = TRUE)`                       |
#' @name yaml_templates
#' @aliases yaml_templates
#' @export
use_travis_yml <- function(type) {
  if (type == "linux") {
    os <- readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-linux.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-no-deploy.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "linux-matrix") {
    os <- readLines(system.file("templates/travis-linux.yml",
      package = "tic"
    ))
    meta <- readLines(system.file("templates/travis-meta-linux.yml",
      package = "tic"
    ))
    matrix <- readLines(system.file("templates/travis-matrix-no-pkgdown.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-no-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, matrix, env, stages)
  } else if (type == "linux-deploy") {
    os <- readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-linux.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "linux-deploy-matrix" || type == "linux-matrix-deploy") {
    os <- readLines(system.file("templates/travis-linux.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-linux.yml",
      package = "tic"
    ))
    matrix <- readLines(system.file("templates/travis-matrix-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, matrix, stages)
  } else if (type == "macos") {
    os <- readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-no-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "macos-matrix") {
    os <- readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    matrix <- readLines(system.file("templates/travis-matrix-no-pkgdown.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-no-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, matrix, env, stages)
  } else if (type == "linux-macos-matrix") {
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    os <- readLines(system.file("templates/travis-matrix-linux-macos-no-pkgdown.yml", # nolint
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-no-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "linux-macos-deploy-matrix") {
    os <- readLines(system.file("templates/travis-matrix-linux-macos-pkgdown.yml",
      package = "tic"
    ))
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "linux-macos") {
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    os <- readLines(system.file("templates/travis-linux-macos-no-pkgdown.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-no-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "linux-macos-deploy") {
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    os <- readLines(system.file("templates/travis-linux-macos-pkgdown.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "macos-deploy") {
    os <- readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, env, stages)
  } else if (type == "macos-deploy-matrix" || type == "macos-matrix-deploy") {
    os <- readLines(system.file("templates/travis-macos.yml", package = "tic"))
    meta <- readLines(system.file("templates/travis-meta-macos.yml",
      package = "tic"
    ))
    matrix <- readLines(system.file("templates/travis-matrix-pkgdown.yml",
      package = "tic"
    ))
    env <- readLines(system.file("templates/travis-env-no-pkgdown.yml",
      package = "tic"
    ))
    stages <- readLines(system.file("templates/travis-deploy.yml",
      package = "tic"
    ))
    template <- c(os, meta, matrix, env, stages)
  }
  writeLines(template, ".travis.yml")
}

#' @rdname yaml_templates
#' @export
use_appveyor_yml <- function(type) {
  if (type == "windows") {
    template <- readLines(system.file("templates/appveyor.yml",
      package = "tic"
    ))
  } else if (type == "windows-matrix") {
    template <- readLines(system.file("templates/appveyor-matrix.yml",
      package = "tic"
    ))
  }
  writeLines(template, "appveyor.yml")
}

#' @rdname yaml_templates
#' @export
use_circle_yml <- function(type) {
  if (type == "linux") {
    template <- readLines(system.file("templates/circle.yml", package = "tic"))
  } else if (type == "linux-matrix") {
    template <- readLines(system.file("templates/circle-matrix.yml",
      package = "tic"
    ))
  } else if (type == "linux-deploy") {
    template <- readLines(system.file("templates/circle-deploy.yml",
      package = "tic"
    ))
  } else if (type == "linux-deploy-matrix" || type == "linux-matrix-deploy") {
    template <- readLines(system.file("templates/circle-deploy-matrix.yml",
      package = "tic"
    ))
  }
  dir.create(".circleci", showWarnings = FALSE)
  writeLines(template, con = ".circleci/config.yml")
}

#' @rdname yaml_templates
#' @export
use_ghactions_yml <- function(type = "all", deploy = FALSE) {

  if (deploy == TRUE) {
    type = "all-deploy"
  }

  # .ccache dir lives in the package root because we cannot write elsewhere
  # -> need to ignore it for R CMD check
  usethis::use_build_ignore(c(".ccache", ".github"))

  if (type == "linux" | type == "macOS" | type == "linux-macos" |
    type == "linux-macos-windows" | type == "all") {
    meta <- readLines(system.file("templates/ghactions-meta.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "linux-deploy" | type == "macOS-deploy" |
    type == "linux-macos-deploy" |
    type == "linux-macos-windows-deploy" |
    type == "all-deploy") {
    meta <- readLines(system.file("templates/ghactions-meta.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  }
  dir.create(".github/workflows", showWarnings = FALSE, recursive = TRUE)
  cli::cli_alert_info("Please comment in/out the platforms you want to use
                      in {.file .github/workflows/main.yml}.", wrap = TRUE)
  cli::cli_text("Call {.code usethis::edit_file('.github/workflows/main.yml')}
                to open the YAML file.")
  writeLines(template, con = ".github/workflows/main.yml")
}

use_tic_template <- function(template, save_as = template, open = FALSE,
                             ignore = TRUE, data = NULL) {
  usethis::use_template(
    template, save_as,
    package = "tic", open = open, ignore = ignore, data = data
  )
}
