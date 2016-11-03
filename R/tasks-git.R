InstallSSHKeys <- R6Class(
  "InstallSSHKeys", inherit = TravisTask,

  public = list(
    run = function() {
      message("Decrypting deploy key")
      deploy_key <- openssl::aes_cbc_decrypt(
        ".deploy_key.enc", openssl::base64_decode(Sys.getenv("encryption_key")),
        openssl::base64_decode(Sys.getenv("encryption_iv"))
      )
      deploy_key_path <- file.path("~/.ssh", "id_rsa")
      if (file.exists(deploy_key_path)) {
        stop("Not overwriting key", call. = FALSE)
      }
      message("Writing deploy key to ", deploy_key_path)
      writeBin(deploy_key, deploy_key_path)
      Sys.chmod(deploy_key_path, "600")
    },

    prepare = function() {
      if (!requireNamespace("openssl", quietly = TRUE))
        install.packages("openssl")
    },

    check = function() {
      # only run on pushes
      Sys.getenv("TRAVIS_EVENT_TYPE") == "push"
    }
  )
)

#' @export
task_install_ssh_keys <- InstallSSHKeys$new
