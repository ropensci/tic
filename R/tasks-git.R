InstallSSHKeys <- R6Class(
  "InstallSSHKeys", inherit = TravisTask,

  public = list(
    run = function() {
      message("Decrypting deploy key")
      deploy_key_path <- file.path("~/.ssh", "id_rsa")
      if (file.exists(deploy_key_path)) {
        stop("Not overwriting key", call. = FALSE)
      }
      message("Writing deploy key to ", deploy_key_path)
      writeLines(Sys.getenv("id_rsa"), deploy_key_path)
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
