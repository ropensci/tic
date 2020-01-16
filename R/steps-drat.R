AddToDrat <- R6Class(
  "AddToDrat",
  inherit = TicStep,

  public = list(
    prepare = function() {
      verify_install(c("drat", "remotes", "rmarkdown", "withr", "pkgbuild"))
    },

    run = function() {
      path <- pkgbuild::build(binary = (getOption("pkgType") != "source"))
      drat::insertPackage(path)
    }
  )
)

#' Step: Add built package to a drat
#'
#' Builds a package (binary on OS X or Windows) and inserts it into an existing
#' \pkg{drat} repository via [drat::insertPackage()].
#' @family steps
#' @export
#' @examples
#' dsl_init()
#'
#' get_stage("script") %>%
#'   add_step(step_add_to_drat())
#'
#' dsl_get()
step_add_to_drat <- function() {
  AddToDrat$new()
}
