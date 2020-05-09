#' @title Use CI YAML templates
#' @description Installs YAML templates for various CI providers. These functions
#'   are also used within [use_tic()].
#'
#'   If you want to update an existing template use [update_yml()].
#'
#' @param type `[character]`\cr
#'   Which template to use. The string should be given following the logic
#'   `<platform>-<action>`. See details for more.
#' @param write `[logical]`\cr
#'   Whether to write the template to disk (`TRUE`) or just return it (`FALSE`).
#' @param quiet `[logical]`\cr
#'   Whether to print informative messages.
#' @section pkgdown:
#'  If `type` contains "deploy", {tic} by default also sets the environment
#'  variable `BUILD_PKGDOWN=true`. This triggers a call to
#'  `pkgdown::build_site()` via the `do_pkgdown` macro in `tic.R` for the
#'  respective runners.
#'
#'  If a setting  includes "matrix" and builds on multiple R versions, the job
#'  building on R release is chosen to build the pkgdown site.
#'
#' @section YAML Type:
#' `tic` supports a variety of different YAML templates which follow the
#'  `<platform>-<action>` pattern. The first one is mandatory, the
#'  others are optional.
#'
#'  * Possible values for `<platform>` are `linux`, and `macos`, `windows`.
#'  * Possible values for `<action>` are `matrix` and `deploy`.
#'
#'  Not every combinations is supported on all CI systems.
#'  For example, for `use_appveyor_yaml()` only `windows` and `windows-matrix`
#'  are valid.
#'
#'  For backward compatibility `use_ghactions_yml()` will be default build and
#'  deploy on all platforms.
#'
#'  Here is a list of all available combinations:
#'  | Provider   | Operating system         | Deployment | multiple R versions | Call                                                    |
#'  | -------    | ----------------         | ---------- | ------------------- | ------------------------------------------------------- |
#'  |----------  |------------------        |------------|---------------------|---------------------------------------------------------|
#'  | Travis     | Linux                    | no         | no                  | `use_travis_yml("linux")`                               |
#'  |            | Linux                    | yes        | no                  | `use_travis_yml("linux-deploy")`                        |
#'  |            | Linux                    | no         | yes                 | `use_travis_yml("linux-matrix")`                        |
#'  |            | Linux                    | yes        | yes                 | `use_travis_yml("linux-deploy-matrix")`                 |
#'  |            | macOS                    | no         | no                  | `use_travis_yml("macos")`                               |
#'  |            | macOS                    | yes        | no                  | `use_travis_yml("macos-deploy")`                        |
#'  |            | macOS                    | no         | yes                 | `use_travis_yml("macos-matrix")`                        |
#'  |            | macOS                    | yes        | yes                 | `use_travis_yml("macos-deploy-matrix")`                 |
#'  |            | Linux + macOS            | no         | no                  | `use_travis_yml("linux-macos")`                         |
#'  |            | Linux + macOS            | yes        | no                  | `use_travis_yml("linux-macos-deploy")`                  |
#'  |            | Linux + macOS            | no         | yes                 | `use_travis_yml("linux-macos-matrix")`                  |
#'  |            | Linux + macOS            | yes        | yes                 | `use_travis_yml("linux-macos-deploy-matrix")`           |
#'  |----------  |------------------        |------------|---------------------|---------------------------------------------------------|
#'  | Circle     | Linux                    | no         | no                  | `use_circle_yml("linux")`                               |
#'  |            | Linux                    | yes        | no                  | `use_travis_yml("linux-deploy")`                        |
#'  |            | Linux                    | no         | yes                 | `use_travis_yml("linux-matrix")`                        |
#'  |            | Linux                    | no         | yes                 | `use_travis_yml("linux-deploy-matrix")`                 |
#'  |----------  |------------------        |------------|---------------------|---------------------------------------------------------|
#'  | Appveyor   | Windows                  | no         | no                  | `use_appveyor_yml("windows")`                           |
#'  |            | Windows                  | no         | yes                 | `use_travis_yml("windows-matrix")`                      |
#'  |----------  |------------------        |------------|---------------------|---------------------------------------------------------|
#'  | GH Actions | Linux                    | no         | no                  | `use_ghactions_yml("linux")`                           -|
#'  |            | Linux                    | yes        | no                  | `use_ghactions_yml("linux-deploy)`                      |
#'  |            | macOS                    | no         | no                  | `use_ghactions_yml("macos)`                             |
#'  |            | macOS                    | yes        | no                  | `use_ghactions_yml("macos-deploy)`                      |
#'  |            | Windows                  | no         | no                  | `use_ghactions_yml("windows)`                           |
#'  |            | Windows                  | yes        | no                  | `use_ghactions_yml("windows-deploy)`                    |
#'  |            | Linux + macOS            | no         | no                  | `use_ghactions_yml("linux-macos")`                      |
#'  |            | Linux + macOS            | yes        | no                  | `use_ghactions_yml("linux-macos-deploy")`               |
#'  |            | Linux + Windows          | no         | no                  | `use_ghactions_yml("linux-windows")`                    |
#'  |            | Linux + Windows          | yes        | no                  | `use_ghactions_yml("linux-windows-deploy")`             |
#'  |            | macOS + Windows          | no         | no                  | `use_ghactions_yml("macos-windows")`                    |
#'  |            | macOS + Windows          | yes        | no                  | `use_ghactions_yml("macos-windows-deploy")`             |
#'  |            | Linux + macOS + Windows  | no         | no                  | `use_ghactions_yml("linux-macos-windows")`              |
#'  |            | Linux + macOS + Windows  | yes        | no                  | `use_ghactions_yml("linux-macos-windows-deploy")`       |
#' @name yaml_templates
#' @aliases yaml_templates
#' @seealso update_yml
#' @export
use_travis_yml <- function(type = "linux-macos-deploy-matrix",
                           write = TRUE,
                           quiet = FALSE) {
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
  if (!write) {
    return(template)
  } else {
    writeLines(template, ".travis.yml")
  }

  if (!quiet) {
    cat_bullet(
      "Below is the file structure of the new/changed files:",
      bullet = "arrow_down", bullet_col = "blue"
    )
    data <- data.frame(
      stringsAsFactors = FALSE,
      package = c(
        basename(getwd()), ".travis.yml"
      ),
      dependencies = I(list(
        ".travis.yml", character(0)
      ))
    )
    print(tree(data, root = basename(getwd())))
  }
}

#' @rdname yaml_templates
#' @export
use_appveyor_yml <- function(type = "windows",
                             write = TRUE,
                             quiet = FALSE) {
  if (type == "windows") {
    template <- readLines(system.file("templates/appveyor.yml",
      package = "tic"
    ))
  } else if (type == "windows-matrix") {
    template <- readLines(system.file("templates/appveyor-matrix.yml",
      package = "tic"
    ))
  }
  if (!write) {
    return(template)
  } else {
    writeLines(template, "appveyor.yml")
  }

  if (!quiet) {
    cat_bullet(
      "Below is the file structure of the new/changed files:",
      bullet = "arrow_down", bullet_col = "blue"
    )
    data <- data.frame(
      stringsAsFactors = FALSE,
      package = c(
        basename(getwd()), "appveyor.yml"
      ),
      dependencies = I(list(
        "appveyor.yml", character(0)
      ))
    )
    print(tree(data, root = basename(getwd())))
  }
}

#' @rdname yaml_templates
#' @export
use_circle_yml <- function(type = "linux-matrix-deploy",
                           write = TRUE,
                           quiet = FALSE) {
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
  if (!write) {
    return(template)
  } else {
    writeLines(template, ".circleci/config.yml")
  }

  if (!quiet) {
    cat_bullet(
      "Below is the file structure of the new/changed files:",
      bullet = "arrow_down", bullet_col = "blue"
    )
    data <- data.frame(
      stringsAsFactors = FALSE,
      package = c(
        basename(getwd()), ".circleci", "config.yml"
      ),
      dependencies = I(list(
        ".circleci", "config.yml", character(0)
      ))
    )
    print(tree(data, root = basename(getwd())))
  }
}

#' @rdname yaml_templates
#' @export
use_ghactions_yml <- function(type = "linux-macos-windows-deploy",
                              write = TRUE,
                              quiet = FALSE) {

  # .ccache dir lives in the package root because we cannot write elsewhere
  # -> need to ignore it for R CMD check
  usethis::use_build_ignore(c(".ccache", ".github"))
  usethis::use_build_ignore("^clang-.*", escape = FALSE)
  usethis::use_build_ignore("^gfortran.*", escape = FALSE)

  if (type == "linux-matrix" || type == "linux") {
    meta <- readLines(system.file("templates/ghactions-meta-linux.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "linux-matrix-deploy" || type == "linux-deploy-matrix" || type == "linux-deploy") {
    meta <- readLines(system.file("templates/ghactions-meta-linux-deploy.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  } else if (type == "macos-matrix" || type == "macos") {
    meta <- readLines(system.file("templates/ghactions-meta-macos.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "macos-matrix-deploy" || type == "macos-deploy-matrix" || type == "macos-deploy") {
    meta <- readLines(system.file("templates/ghactions-meta-macos-deploy.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  } else if (type == "windows-matrix" || type == "windows") {
    meta <- readLines(system.file("templates/ghactions-meta-windows.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "windows-matrix-deploy" || type == "windows-deploy-matrix" || type == "windows-deploy") {
    meta <- readLines(system.file("templates/ghactions-meta-windows-deploy.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  } else if (type == "linux-macos" || type == "linux-macos-matrix") {
    meta <- readLines(system.file("templates/ghactions-meta-linux-macos.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "linux-macos-deploy" || type == "linux-macos-deploy-matrix") {
    meta <- readLines(system.file("templates/ghactions-meta-linux-macos.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  } else if (type == "linux-windows" || type == "linux-windows-matrix") {
    meta <- readLines(system.file("templates/ghactions-meta-linux-windows.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "linux-windows-deploy" || type == "linux-windows-deploy-matrix") {
    meta <- readLines(system.file("templates/ghactions-meta-linux-windows.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  } else if (type == "macos-windows" || type == "macos-windows-matrix") {
    meta <- readLines(system.file("templates/ghactions-meta-macos-windows.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "macos-windows-deploy" || type == "macos-windows-deploy-matrix") {
    meta <- readLines(system.file("templates/ghactions-meta-macos-windows.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  } else if (type == "linux-macos-windows") {
    meta <- readLines(system.file("templates/ghactions-meta.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "linux-macos-windows-deploy" || type == "all") {
    meta <- readLines(system.file("templates/ghactions-meta.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  }
  dir.create(".github/workflows", showWarnings = FALSE, recursive = TRUE)

  if (!quiet) {
    cli::cli_alert_info("Please comment in/out the platforms you want to use
                      in {.file .github/workflows/main.yml}.", wrap = TRUE)
    cli::cli_text("Call {.code usethis::edit_file('.github/workflows/main.yml')}
                to open the YAML file.")
  }

  if (!write) {
    return(template)
  }
  writeLines(template, con = ".github/workflows/main.yml")

  if (!quiet) {
    cat_bullet(
      "Below is the file structure of the new/changed files:",
      bullet = "arrow_down", bullet_col = "blue"
    )
    data <- data.frame(
      stringsAsFactors = FALSE,
      package = c(
        basename(getwd()), ".github", "workflows", "main.yml"
      ),
      dependencies = I(list(
        ".github", "workflows", "main.yml", character(0)
      ))
    )
    print(tree(data, root = basename(getwd())))
  }
}

use_tic_template <- function(template, save_as = template, open = FALSE,
                             ignore = TRUE, data = NULL) {
  usethis::use_template(
    template, save_as,
    package = "tic", open = open, ignore = ignore, data = data
  )
}
