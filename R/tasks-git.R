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
      writeLines(rawToChar(openssl::base64_decode(Sys.getenv("id_rsa"))),
                 deploy_key_path)
      Sys.chmod(deploy_key_path, "600")
    },

    prepare = function() {
      if (!requireNamespace("openssl", quietly = TRUE))
        install.packages("openssl")
    },

    check = function() {
      # only if id_rsa is available
      Sys.getenv("id_rsa") != ""
    }
  )
)

#' @export
task_install_ssh_keys <- InstallSSHKeys$new

TestSSH <- R6Class(
  "TestSSH", inherit = TravisTask,

  public = list(
    initialize = function(host = "git@github.com") {
      private$host <- host
    },

    run = function() {
      message("Trying to ssh into git@github.com")
      system2("ssh", c(private$host, "-vv"))
    }
  ),

  private = list(
    host = NULL
  )
)

#' @export
task_test_ssh <- TestSSH$new
