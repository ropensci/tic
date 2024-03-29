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
#'  Special types are `custom` and `custom-deploy`. These should be used if the
#'  runner matrix is completely user-defined. This is mainly useful in
#'  [update_yml()].
#'
#'  For backward compatibility `use_ghactions_yml()` will be default build and
#'  deploy on all platforms.
#'
#'  Here is a list of all available combinations:
#'
#'  | Provider   | Operating system         | Deployment | multiple R versions | Call                                                    |
#'  | ---------- | ------------------------ | ---------- | ------------------- | ------------------------------------------------------- |
#'  | Circle     | Linux                    | no         | no                  | `use_circle_yml("linux")`                               |
#'  |            | Linux                    | yes        | no                  | `use_circle_yml("linux-deploy")`                        |
#'  |            | Linux                    | no         | yes                 | `use_circle_yml("linux-matrix")`                        |
#'  |            | Linux                    | no         | yes                 | `use_circle_yml("linux-deploy-matrix")`                 |
#'  | ---------- | ------------------------ | ---------- | ------------------- | ------------------------------------------------------- |
#'  | GH Actions | Linux                    | no         | no                  | `use_ghactions_yml("linux")`                            |
#'  |            | Linux                    | yes        | no                  | `use_ghactions_yml("linux-deploy")`                      |
#'  |            | custom                   | no         | no                  | `use_ghactions_yml("custom")`                            |
#'  |            | custom-deploy            | yes        | no                  | `use_ghactions_yml("custom-deploy")`                     |
#'  |            | macOS                    | no         | no                  | `use_ghactions_yml("macos")`                             |
#'  |            | macOS                    | yes        | no                  | `use_ghactions_yml("macos-deploy")`                      |
#'  |            | Windows                  | no         | no                  | `use_ghactions_yml("windows")`                           |
#'  |            | Windows                  | yes        | no                  | `use_ghactions_yml("windows-deploy")`                    |
#'  |            | Linux + macOS            | no         | no                  | `use_ghactions_yml("linux-macos")`                      |
#'  |            | Linux + macOS            | yes        | no                  | `use_ghactions_yml("linux-macos-deploy")`               |
#'  |            | Linux + Windows          | no         | no                  | `use_ghactions_yml("linux-windows")`                    |
#'  |            | Linux + Windows          | yes        | no                  | `use_ghactions_yml("linux-windows-deploy")`             |
#'  |            | macOS + Windows          | no         | no                  | `use_ghactions_yml("macos-windows")`                    |
#'  |            | macOS + Windows          | yes        | no                  | `use_ghactions_yml("macos-windows-deploy")`             |
#'  |            | Linux + macOS + Windows  | no         | no                  | `use_ghactions_yml("linux-macos-windows")`              |
#'  |            | Linux + macOS + Windows  | yes        | no                  | `use_ghactions_yml("linux-macos-windows-deploy")`       |
#'
#' @name yaml_templates
#' @export
use_circle_yml <- function(type = "linux-deploy",
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
use_ghactions_yml <- function(type = "linux-deploy",
                              write = TRUE,
                              quiet = FALSE) {

  # .ccache dir lives in the package root because we cannot write elsewhere
  # -> need to ignore it for R CMD check
  usethis::use_build_ignore(c(".ccache", ".github"))

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
  } else if (type == "custom") {
    meta <- readLines(system.file("templates/ghactions-meta-custom.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    template <- c(meta, env, core)
  } else if (type == "custom-deploy") {
    meta <- readLines(system.file("templates/ghactions-meta-custom-deploy.yml", package = "tic"))
    env <- readLines(system.file("templates/ghactions-env.yml", package = "tic"))
    core <- readLines(system.file("templates/ghactions-core.yml", package = "tic"))
    deploy <- readLines(system.file("templates/ghactions-deploy.yml", package = "tic"))
    template <- c(meta, env, core, deploy)
  }
  dir.create(".github/workflows", showWarnings = FALSE, recursive = TRUE)

  if (!quiet) {
    cli::cli_alert_info("Please comment in/out the platforms you want to use
                      in {.file .github/workflows/tic.yml}.", wrap = TRUE)
    cli::cli_text("Call {.code usethis::edit_file('.github/workflows/tic.yml')}
                to open the YAML file.")
  }

  if (!write) {
    return(template)
  }
  cli::cli_alert_info("Writing {.file .github/workflows/tic.yml}.")
  writeLines(template, con = ".github/workflows/tic.yml")

  if (!quiet) {
    cat_bullet(
      "Below is the file structure of the new/changed files:",
      bullet = "arrow_down", bullet_col = "blue"
    )
    data <- data.frame(
      stringsAsFactors = FALSE,
      package = c(
        basename(getwd()), ".github", "workflows", "tic.yml"
      ),
      dependencies = I(list(
        ".github", "workflows", "tic.yml", character(0)
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
