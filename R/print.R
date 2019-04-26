#' @import cli
#' @export
print.TicStages <- function(x, ...) {
  lapply(x, print, omit_if_empty = TRUE)
  invisible(x)
}

#' @export
print.TicStage <- function(x, ..., omit_if_empty = FALSE) {
  x$print(omit_if_empty = omit_if_empty)
  invisible(x)
}
