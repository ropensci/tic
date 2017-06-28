AddToDrat <- R6Class(
  "AddToDrat", inherit = TicStep,

  public = list(
    prepare = function() {
      verify_install("drat", "remotes", "knitr", "withr")
      remotes::install_github("r-lib/pkgbuild")
    },

    run = function() {
      path <- pkgbuild::build(binary = (getOption("pkgType") != "source"))
      drat::insertPackage(path)
      withr::with_dir(
        "~/git/drat",
        knitr::knit("index.Rmd", "index.md")
      )
    }
  )
)

#' Step: Add built package to a drat
#'
#' Builds a package (binary on OS X or Windows) and inserts it into an existing
#' \pkg{drat} repository via [drat::insertPackage()].
#'
#' @family steps
#' @export
step_add_to_drat <- AddToDrat$new
