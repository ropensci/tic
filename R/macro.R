#' Macros
#'
#' The [DSL] offers a fine-grained interface to the individual stages
#' of a CI run.
#' Macros are tic's way of adding several related steps to the relevant
#' stages.
#' All macros use the `do_` prefix.
#' @name macro
NULL

#' List available macros
#'
#' @description Lists available macro functions of the `tic` package.
#' @return [character]
#' @family macros
#' @export
list_macros = function() {
  requireNamespace("utils", quietly = TRUE)
  as.character(utils::lsf.str("package:tic", pattern = "^do_"))
}

