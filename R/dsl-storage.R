# Modeled after usethis::proj_get() et al.

.dsl_storage <- new.env(parent = emptyenv())

dslobj_has <- function() {
  !is.null(.dsl_storage$dsl)
}

dslobj_get <- function() {
  .dsl_storage$dsl # nolint
}

dslobj_set <- function(dsl) {
  .dsl_storage$dsl <- dsl
}

dslobj_new <- function(envir = parent.frame()) {
  dsl <- TicDSL$new()
  parent.env(dsl) <- envir
  dsl
}

dslobj_init <- function(envir = parent.frame()) {
  dsl <- dslobj_new(envir) # nolint
  dslobj_set(dsl)
}


#' Stages and steps
#'
#' @description
#' \pkg{tic} works in a declarative way, centered around the `tic.R` file
#' created by [use_tic()].
#' This file contains the *definition* of the steps to be run in each stage:
#' calls to [get_stage()] and [add_step()], or macros like
#' [do_package_checks()].
#'
#' Normally, this file is never executed directly.
#' Running these functions in an interactive session will **not** carry out
#' the respective actions.
#' Instead, a description of the code that would have been run is printed
#' to the console.
#' Edit `tic.R` to configure your CI builds.
#' See `vignette("build-lifecycle", package = "tic")` for more details.
#'
#' @details
#' Stages and steps defined using tic's [DSL] are stored in an
#' internal object in the package.
#' The stages are accessible through `dsl_get()`.
#' When running the [stages], by default a configuration defined
#' in the `tic.R` file is loaded with `dsl_load()`.
#' See [use_tic()] for setting up a `tic.R` file.
#'
#' For interactive tests, an empty storage can be initialized
#' with `dsl_init()`.
#' This happens automatically the first time `dsl_get()` is called
#' (directly or indirectly).
#'
#' @return A named list of opaque stage objects with a `"class"` attribute
#' and a corresponding [print()] method for pretty output.
#' Use the high-level [get_stage()] and [add_step()] functions to configure,
#' and the [stages] functions to run.
#'
#' @export
#' @examples
#' \dontrun{
#' dsl_init()
#' dsl_get()
#'
#' dsl_load(system.file("templates/package/tic.R", package = "tic"))
#' dsl_load(system.file("templates/package/tic.R", package = "tic"),
#'   force =
#'     TRUE
#' )
#' dsl_get()
#' }
dsl_get <- function() {
  if (!dslobj_has()) {
    dsl_init()
  }

  dslobj_get()$get_stages()
}

#' dsl_load
#'
#' @param path `[string]`\cr
#'   Path to the stage definition file, default: `"tic.R"`.
#' @param force `[flag]`\cr
#'   Set to `TRUE` to force loading from file even if a configuration exists.
#'   By default an existing configuration is not overwritten by `dsl_load()`.
#' @param quiet `[flag]`\cr
#'   Set to `TRUE` to turn off verbose output.
#'
#' @importFrom utils packageName
#' @rdname dsl_get
#' @export
dsl_load <- function(path = "tic.R", force = FALSE, quiet = FALSE) {
  Sys.setenv("R_CLI_NUM_COLORS" = as.integer(256^3))
  if (dslobj_has() && !force) {
    if (!quiet) {
      if (Sys.getenv("CI") == "") {
        cat_bullet(
          "Using existing tic stage configuration, use ",
          crayon::silver("`force = TRUE`"), " to reload",
          bullet = "info", bullet_col = "green"
        )
      }
    }
  } else {
    if (!quiet) {
      if (Sys.getenv("CI") == "") {
        cat_bullet(
          "Loading tic stage configuration from ", crayon::blue(path),
          bullet = "tick", bullet_col = "green"
        )
      }
    }

    # Restore old DSL in case of failure
    old_dsl <- dslobj_get()
    on.exit(dslobj_set(old_dsl))

    env <- asNamespace(packageName())
    source_env <- new.env(parent = env)
    # FIXME: Is dsl actually used?
    dsl <- dslobj_init(envir = env) # nolint
    source(path, local = source_env)

    # All good, don't need to restore anything
    on.exit(NULL, add = FALSE)
  }

  invisible(dsl_get())
}

#' dsl_init
#'
#' @rdname dsl_get
#' @export
dsl_init <- function(quiet = FALSE) {
  if (!quiet) {
    cli_alert_success("Creating a clean tic stage configuration")
    cli_alert_info("See {.code ?tic::dsl_get} for details")
  }

  env <- asNamespace(packageName())
  # FIXME: Is dsl actually used?
  dsl <- dslobj_init(envir = env) # nolint

  invisible(dsl_get())
}
