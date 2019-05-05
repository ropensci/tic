AddToDrat <- R6Class(
  "AddToDrat",
  inherit = TicStep,

  public = list(
    prepare = function() {
      verify_install("drat", "remotes", "knitr", "withr", "pkgbuild")
    },

    run = function() {
      path <- pkgbuild::build(binary = (getOption("pkgType") != "source"))
      drat::insertPackage(path)
      withr::with_dir(
        "~/git/drat",
        if (file.exists("index.Rmd")) {
          knitr::knit("index.Rmd", "index.md")
        }
      )
    }
  )
)

#' Step: Add built package to a drat
#'
#' Builds a package (binary on OS X or Windows) and inserts it into an existing
#' \pkg{drat} repository via [drat::insertPackage()].
#' Also knits the `index.Rmd` file of the drat if it exists.
#'
#' @family steps
#' @export
step_add_to_drat <- function() {
  AddToDrat$new()
}
