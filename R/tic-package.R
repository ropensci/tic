#' @details
#' The `travis::use_tic()` function prepares a code repository for use with
#' this package. See [DSL] for an overview of \pkg{tic}'s domain-specific
#' language for defining stages and steps, and [step_hello_world()] and the
#' links therein for available steps.
#' @importFrom crayon has_color
#' @importFrom memoise memoise
#' @aliases NULL
"_PACKAGE"

# Import methods, to make sure it is available when Rscript is used on Windows
# to run tic verbs
# Reference: https://github.com/tidyverse/hms/commit/0a301d895d35ca61e8d702df58154b8be45900ce
#' @importFrom methods setOldClass
NULL
