AddToDrat <- R6Class(
  "AddToDrat", inherit = TicStep,

  public = list(
    prepare = function() {
      verify_install("drat", "remotes")
      remotes::install_github("r-lib/pkgbuild")
    },

    run = function() {
      path <- pkgbuild::build(binary = (getOption("pkgType") != "source"))
      drat::insertPackage(path)
    }
  )
)

#' @export
step_add_to_drat <- AddToDrat$new
