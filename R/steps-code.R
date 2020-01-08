RunCode <- R6Class(
  "RunCode",
  inherit = TicStep,

  public = list(
    initialize = function(call, prepare_call = NULL) {
      private$call <- enexpr(call)
      private$prepare_call <- enexpr(prepare_call)
      private$seed <- 123
    },

    run = function() {
      set.seed(private$seed)
      eval(private$call, envir = .GlobalEnv)
    },

    prepare = function() {
      # allow installation of packages from nonstandard repositories, e.g.
      # Github packages using a repo slug
      if (!is.null(private$prepare_call)) {
        private$install_call_dep(private$prepare_call)
        set.seed(private$seed)
        eval(private$prepare_call, envir = .GlobalEnv)
      } else {
        private$install_call_dep(private$call)
      }
    }
  ),

  private = list(
    call = NULL,
    prepare_call = NULL,
    seed = NULL,

    install_call_dep = function(call) {
      pkg_name <- unique(get_deps_from_code(call))
      base_packages <- rownames(utils::installed.packages(priority = "base"))
      pkg_name <- setdiff(pkg_name, base_packages)

      verify_install(pkg_name)
    }
  )
)

#' Step: Run arbitrary R code
#'
#' Captures the expression and executes it when running the step.
#' An optional preparatory expression can be provided that is executed
#' during preparation.
#' If the top-level expression is a qualified function call (of the format
#' `package::fun()`), the package is installed during preparation.
#'
#' @param call `[call]`\cr
#'   An arbitrary R expression executed during the stage to which this step is
#'   added.
#'   The default is useful if you only pass `prepare_call`.
#' @param prepare_call `[call]`\cr
#'   An optional arbitrary R expression executed during preparation.
#' @family steps
#' @export
#' @examples
#' \dontrun{
#' dsl_init()
#'
#' get_stage("install") %>%
#'   add_step(step_run_code(update.packages(ask = FALSE)))
#'
#' # Will install covr from CRAN during preparation:
#' get_stage("after_success") %>%
#'   add_code_step(covr::codecov())
#'
#' dsl_get()
#' }
step_run_code <- function(call = NULL, prepare_call = NULL) {
  if (interactive()) {
    stop("step_* functions should only be used in tic.R and not interactively.")
  }
  RunCode$new(!!enexpr(call), !!enexpr(prepare_call))
}
