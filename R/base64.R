#' Helpers for converting R objects to strings and back
#'
#' @description
#' `base64serialize()` converts an R object into a string suitable for storing
#' in an environment variable. Use this function for encoding entire R objects
#' (such as OAuth tokens) so that they can be used in Travis builds.
#'
#' @param x Object to serialize or deserialize
#' @param compression Passed on as `type` argument to [memCompress()] or
#'   [memDecompress()].
#' @export
#' @examples
#' serial <- base64serialize(1:10)
base64serialize <- function(x, compression = "gzip") {
  raw <- serialize(x, connection = NULL)
  compressed <- memCompress(raw, type = compression)
  encoded <- base64enc::base64encode(compressed)
  encoded
}

#' @rdname base64serialize
#' @description
#' `base64unserialize()` is the inverse operation to `base64serialize()`.
#' Use this function in your `tic.R` to access the R object previously encoded
#' by `base64serialize()`.
#'
#' @export
#' @examples
#' base64unserialize(serial)
base64unserialize <- function(x, compression = "gzip") {
  decoded <- base64enc::base64decode(x)
  expanded <- memDecompress(decoded, type = compression)
  ret <- unserialize(expanded)
  ret
}
