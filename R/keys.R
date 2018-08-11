#' Get public RSA key
#'
#' Gets a public RSA keygen
#'
#' @param key RSA key, as returned by [openssl::rsa_keygen()]
#' @seealso [usethis::use_ci()] [usethis::use_travis_deploy()]
#' @seealso [step_install_ssh_keys()] [step_test_ssh()] [step_setup_ssh()]
#' @keywords internal
#' @export
get_public_key <- function(key) {
  as.list(key)$pubkey
}

#' Encode a private RSA key
#'
#' Encodes a private RSA keygen
#' @inheritParams get_public_key
#' @seealso [usethis::use_ci()] [usethis::use_travis_deploy()]
#' @seealso [step_install_ssh_keys()] [step_test_ssh()] [step_setup_ssh()]
#' @keywords internal
#' @export
encode_private_key <- function(key) {
  if (!requireNamespace("openssl", quietly = FALSE)) {
    stopc("Please install the openssl package.")
  }

  conn <- textConnection(NULL, "w")
  openssl::write_pem(key, conn, password = NULL)
  private_key <- textConnectionValue(conn)
  close(conn)

  private_key <- paste(private_key, collapse = "\n")

  openssl::base64_encode(charToRaw(private_key))
}
