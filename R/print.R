#' @import cli
#' @export
print.TicStages <- function(x, ...) {
  if (all(vlapply(x, stage_is_empty))) {
    cat_bullet("No steps defined in any stage", bullet = "info", bullet_col = "green")
  } else {
    lapply(x, print, omit_if_empty = TRUE)
  }
  invisible(x)
}

#' @export
print.TicStage <- function(x, ..., omit_if_empty = FALSE) {
  x$print(omit_if_empty = omit_if_empty)
  invisible(x)
}
