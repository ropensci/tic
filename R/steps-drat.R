AddToDrat <- R6Class(
  "AddToDrat",
  inherit = TicStep,

  public = list(
    initialize = function(repo_slug = NULL, deploy_dev = FALSE) {
      private$repo_slug <- repo_slug
      private$deploy_dev <- deploy_dev
    },

    prepare = function() {
      verify_install(c(
        "drat", "remotes", "rmarkdown", "withr", "pkgbuild",
        "desc", "usethis"
      ))
    },

    run = function() {
      if (is.null(private$repo_slug)) {
        stopc("A repository to deploy to is required.")
      }
      ver <- desc::desc_get_version()
      if (length(unlist(ver)) > 3 && deploy_dev == FALSE) {
        cli_alert_info("Detected dev version of current package. Not building
                      package binaries because {.code deploy_dev = FALSE} is
                      set.", wrap = FALSE)
        return(invisible())
      }
      else {
        path <- pkgbuild::build(binary = (getOption("pkgType") != "source"))
        drat::insertPackage(path)
      }
    }
  ),

  private = list(
    repo_slug = NULL,
    deploy_dev = NULL
  )
)

#' Step: Add built package to a drat
#'
#' Builds a package (binary on OS X or Windows) and inserts it into an existing
#' \pkg{drat} repository via [drat::insertPackage()].
#' @param repo_slug `[string]`\cr
#'   The name of the drat repository to deploy to in the form `:owner/:repo`.
#' @param deploy_dev `[logical]`\cr
#'   Should development versions of packages also be deployed to the drat repo?
#'   By default only "major", "minor" and "patch" releases are build and
#'   deployed.
#' @family steps
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_add_to_drat())
#'
#' dsl_get()
step_add_to_drat <- function(repo_slug = NULL, deploy_dev = FALSE) {
  AddToDrat$new(repo_slug = repo_slug, deploy_dev = deploy_dev)
}
