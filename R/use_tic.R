# nocov start

#' @title Initialize CI testing using tic
#' @description Prepares a repo for building and deploying supported by
#' \pkg{tic}.
#'
#' @importFrom utils menu
#' @details
#'
#' 1. Query information which CI providers should be used
#' 1. Setup permissions for providers selected for deployment
#' 1. Create YAML files for selected providers
#' 1. Create a default `tic.R` file depending on the repo type
#'    (package, website, bookdown, ...)
#'
#' @param wizard `[flag]`\cr Interactive operation? If `TRUE`, a menu will be
#'   shown.
#' @param linux `[string]`\cr Which CI provider(s) to use to test on Linux.
#'   Possible options are `"circle"`, `"ghactions"`, `"none"`/`NULL`
#'   and `"all"`.
#' @param windows `[string]`\cr Which CI provider(s) to use to test on Windows
#'   Possible options are `"none"`/`NULL`, and `"ghactions"`.
#' @param mac `[string]`\cr Which CI provider(s) to use to test on macOS
#'   Possible options are `"none"`/`NULL` and `"ghactions"`.
#' @param deploy `[string]`\cr Which CI provider(s) to use to deploy artifacts
#'   such as pkgdown documentation. Possible options are "circle"`,
#'   `"ghactions"`, `"none"`/`NULL` and `"all"`.
#' @param matrix `[string]`\cr For which CI provider(s) to set up matrix builds.
#'   Possible options are  `"circle"`, `"ghactions"`, `"none"`/`NULL`
#'   and `"all"`.
#' @template private_key_name
#' @param quiet `[flag]`\cr Less verbose output? Default: `FALSE`.
#' @export
#' @examples
#' # Requires interactive mode
#' if (FALSE) {
#'   use_tic()
#'
#'   # Pre-specified settings favoring Circle CI:
#'   use_tic(
#'     wizard = FALSE,
#'     linux = "circle",
#'     mac = "ghactions",
#'     windows = "ghactions",
#'     deploy = "circle",
#'     matrix = "all"
#'   )
#' }
use_tic <- function(wizard = interactive(),
                    linux = "ghactions",
                    mac = "ghactions",
                    windows = "ghactions",
                    deploy = "ghactions",
                    matrix = "none",
                    private_key_name = "TIC_DEPLOY_KEY",
                    quiet = FALSE) { # nolint

  cli_alert("Welcome to {.pkg tic}!")
  if (wizard) {
    cli_text(
      "This wizard will guide you through the setup process for getting started
    with various CI providers."
    )
  }

  cli_h1("Introduction:")
  cli_text("{.pkg tic} currently comes with support for four CI providers: ")

  cli_ul(c("Circle CI", "GitHub Actions"))

  cli_par()
  cli_text(c(
    "There is no need to use all of them.",
    " You can choose which one(s) you want to use,",
    " whether you want to deploy (i.e. push from builds)",
    " and if you want to test on multiple R versions."
  ))
  cli_end()

  cli_text("We recommend the following setup:")
  cli_ul(c("GitHub Actions: Linux", "GitHub Actions: macOS", "GitHub Actions: Windows"))
  cli_par()
  cli_end()

  if (wizard) {
    if (yesno("Ready to get started?")) {
      return(invisible(NULL))
    }

    cli_h1("Choosing your setup.")
    cli_text("We'll ask you a few yes/no questions to gather your preferences.")
    cli_par()
    cli_end()

    linux <- ci_menu(c("circle", "ghactions", "none", "all"),
      title = "Which provider do you want to use for Linux builds?"
    )

    mac <- ci_menu(c("ghactions", "none"),
      title = "Do you want to build on macOS?"
    )

    windows <- ci_menu(c("ghactions", "none"),
      title = "Do you want to build on Windows?"
    )

    deploy <- ci_menu(intersect(
      c("circle", "ghactions", "none", "all"),
      c(linux, mac, windows, "all", "none")
    ),
    title = "Do you want to deploy (i.e. push from the CI build to your repo) on certain providers? If yes, which ones?" # nolint
    )

    matrix <- ci_menu(intersect(
      c("none", "circle", "ghactions", "all"),
      c(linux, mac, windows, "all", "none")
    ),
    title = "Do you want to build on multiple R versions? (i.e. R-devel, R-release, r-devel). If yes, on which platform(s)?" # nolint
    )

    wizard <- FALSE
    use_tic_call <- paste0(
      "tic::use_tic(",
      arg_desc(wizard),
      arg_desc(linux),
      arg_desc(mac),
      arg_desc(windows),
      arg_desc(deploy),
      arg_desc(matrix, last = TRUE),
      ")"
    )
    cli_text("If setup fails, rerun with:")
    cli_text("{.code ", use_tic_call, "}")
  } else {
    linux <- match.arg(linux, c("circle", "ghactions", "none", "all"),
      several.ok = TRUE
    )
    mac <- match.arg(mac, c("none", "ghactions"),
      several.ok = TRUE
    )
    windows <- match.arg(windows, c("none", "ghactions", "all"),
      several.ok = TRUE
    )
    deploy <- match.arg(deploy, c("circle", "ghactions", "none", "all"), # nolint
      several.ok = TRUE
    )
    matrix <- match.arg(matrix,
      c("none", "circle", "ghactions", "all"),
      several.ok = TRUE
    )
  }

  cli_h1("Setting up the CI providers")

  cli_text(
    "Next we are getting the selected CI providers ready for deployment.",
    " This requires some interaction with their API and you may need to create
    an API token."
  )
  cli_par()
  cli_end()

  # init deploy ----------------------------------------------------------------

  if (circle_in(deploy)) {
    rule(left = "Circle CI")
    check_circle_pkg()
    circle::enable_repo()
    circle::use_circle_deploy()
  } else if (ghactions_in(deploy)) {
    rule(left = "GitHub Actions")
    check_ghactions_pat()
    tic::use_ghactions_deploy()
  }

  # create YAMLs ---------------------------------------------------------------

  cli_par()
  cli_end()
  cli_h1("Creating YAML files...")

  # Circle ---------------------------------------------------------------------

  cli_h2("Circle CI")

  if (circle_in(linux)) {
    # deployment
    if (circle_in(deploy)) {
      # build matrix
      if (circle_in(matrix)) {
        use_circle_yml("linux-deploy-matrix")
      } else {
        use_circle_yml("linux-deploy")
      }
    } else {
      # build matrix
      if (circle_in(matrix)) {
        use_circle_yml("linux-matrix")
      } else {
        use_circle_yml("linux")
      }
    }
  }

  cli_alert_success("OK")

  # GH Actions -----------------------------------------------------------------

  cli_h2("GitHub Actions")

  # this has to come first as otherwise the conditions jumps into partial
  # matches first
  if (ghactions_in(windows) && ghactions_in(linux) &&
    ghactions_in(mac)) {
    if (ghactions_in(deploy)) {
      use_ghactions_yml("linux-macos-windows-deploy")
    } else {
      use_ghactions_yml("linux-macos-windows")
    }
  } else if (ghactions_in(linux) && ghactions_in(mac)) {
    if (ghactions_in(matrix)) {
      if (ghactions_in(deploy)) {
        use_ghactions_yml("linux-macos-deploy-matrix")
      } else {
        use_ghactions_yml("linux-macos-matrix")
      }
    } else {
      if (ghactions_in(deploy)) {
        use_ghactions_yml("linux-macos-deploy")
      } else {
        use_ghactions_yml("linux-macos")
      }
    }
  } else if (ghactions_in(linux) && ghactions_in(windows)) {
    if (ghactions_in(matrix)) {
      if (ghactions_in(deploy)) {
        use_ghactions_yml("linux-windows-deploy-matrix")
      } else {
        use_ghactions_yml("linux-windows-matrix")
      }
    } else {
      if (ghactions_in(deploy)) {
        use_ghactions_yml("linux-windows-deploy")
      } else {
        use_ghactions_yml("linux-windows")
      }
    }
  } else if (ghactions_in(mac) && ghactions_in(windows)) {
    if (ghactions_in(matrix)) {
      if (ghactions_in(deploy)) {
        use_ghactions_yml("macos-windows-deploy-matrix")
      } else {
        use_ghactions_yml("macos-windows-matrix")
      }
    } else {
      if (ghactions_in(deploy)) {
        use_ghactions_yml("macos-windows-deploy")
      } else {
        use_ghactions_yml("macos-windows")
      }
    }
  } else if (ghactions_in(mac)) {
    if (ghactions_in(deploy)) {
      # build matrix
      if (ghactions_in(matrix)) {
        use_ghactions_yml("macos-deploy-matrix")
      } else {
        use_ghactions_yml("macos-deploy")
      }
    } else {
      # build matrix
      if (ghactions_in(matrix)) {
        use_ghactions_yml("macos-matrix")
      } else {
        use_ghactions_yml("macos")
      }
    }
  } else if (ghactions_in(linux)) {
    # deployment
    if (ghactions_in(deploy)) {
      # build matrix
      if (ghactions_in(matrix)) {
        use_ghactions_yml("linux-deploy-matrix")
      } else {
        use_ghactions_yml("linux-deploy")
      }
    } else {
      # build matrix
      if (ghactions_in(matrix)) {
        use_ghactions_yml("linux-matrix")
      } else {
        use_ghactions_yml("linux")
      }
    }
  }

  cli_par()
  cli_end()
  cli_alert_success("OK")

  # tic.R ----------------------------------------------------------------------

  rule(left = "tic")

  use_tic_r(repo_type = detect_repo_type(), deploy_on = deploy)

  rule("Finished")
  cat_bullet(
    "Done! Thanks for using ", crayon::blue("tic"), ".",
    bullet = "star", bullet_col = "yellow"
  )

  cli::cli_alert_info("Consider also to take a look at
    {.fun tic::use_update_tic} to update your GHA YAML file via GHA. This way,
    your template always gets updated automatically with new template changes.",
    wrap = TRUE
  )
}

arg_desc <- function(arg, last = FALSE) {
  arg_name <- substitute(arg)
  arg_value <- deparse(arg)
  paste0(arg_name, " = ", arg_value, if (!last) ", ")
}

circle_in <- function(x) {
  !all(is.na(match(c("circle", "all"), x)))
}

ghactions_in <- function(x) {
  !all(is.na(match(c("ghactions", "all"), x)))
}

ci_menu <- function(choices, title) {
  if (length(setdiff(choices, c("all", "none"))) <= 1) {
    choices <- setdiff(choices, "all")
  }

  choice_map <- c(
    circle = "Circle CI",
    ghactions = "GitHub Actions",
    all = "All",
    none = "None"
  )

  reply <- menu(choice_map[choices], title = title)
  stopifnot(reply != 0)
  choices[reply]
}

#' Add a tic.R file to the repo
#'
#' @description
#' Adds a `tic.R` file to containing the macros/steps/stages to be run during
#' CI runs.
#'
#' The content depends on the repo type (detected automatically when used within
#' [use_tic()]).
#'
#' @param repo_type (`character(1)`)\cr
#'   Which type of template should be used. Possible values are `"package"`,
#'   `"site"`, `"blogdown"`, `"bookdown"` or `"unknown"`.
#' @param deploy_on (`character(1)`)\cr
#'   Which CI provider should perform deployment? Defaults to `NULL` which means
#'   no deployment will be done. Possible values are `"ghactions"` or `"circle"`.
#' @seealso [yaml_templates], [use_tic_badge()]
#' @export
#' @examples
#' \dontrun{
#' use_tic_r("package")
#' use_tic_r("package", deploy_on = "ghactions")
#' use_tic_r("blogdown", deploy_on = "all")
#' }
use_tic_r <- function(repo_type, deploy_on = "none") {
  cli_par()
  cli_end()
  cli_h2("tic.R")

  # if deploy is requested, we most likely build a pkgdown site and should
  # ignore "docs/" here
  usethis::use_git_ignore("docs/")

  if (repo_type == "unknown") {
    use_tic_template(file.path(
      repo_type,
      "tic.R"
    ), "tic.R")
  } else {
    switch(deploy_on,
      "ghactions" = use_tic_template(file.path(
        repo_type,
        paste0(deploy_on, "-tic.R")
      ), "tic.R"),
      "circle" = use_tic_template(file.path(
        repo_type,
        paste0(deploy_on, "-tic.R")
      ), "tic.R"),
      "all" = use_tic_template(file.path(
        repo_type,
        paste0(deploy_on, "-tic.R")
      ), "tic.R"),
      "none" = use_tic_template(file.path(
        repo_type,
        paste0(deploy_on, "-tic.R")
      ), "tic.R")
    )
  }
}

# This code can only run interactively
# nocov end
