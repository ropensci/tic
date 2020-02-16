# nocov start
#' @include ci.R
GHActionsCI <- R6Class( # nolint
  "GHActionsCI",
  inherit = CI,

  public = list(
    get_branch = function() {
      ref <- Sys.getenv("GITHUB_REF")
      # hopefully this also works for tags
      strsplit(ref, "/", )[[1]][3]
    },
    get_tag = function() {
      # FIXME: No way to get a tag? Merged with env var GITHUB_REF
      # https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
      return("")
    },
    is_tag = function() {
      self$get_tag() == "true"
    },
    get_slug = function() {
      Sys.getenv("GITHUB_REPOSITORY")
    },
    get_build_number = function() {
      # FIXME: Don't know how to get the build number in the url
      return("")
    },
    get_build_url = function() {
      # FIXME: Needs build number
      return("")
    },
    get_commit = function() {
      Sys.getenv("GITHUB_SHA")
    },
    can_push = function(name = "TIC_DEPLOY_KEY") {
      # # id_rsa is the "old" name which was previously hard coded in the {travis}
      # # package. New default name: "TIC_DEPLOY_KEY"
      # # for backward comp we check for the old one too
      # name <- compat_ssh_key(name)
      # self$has_env(name)
      TRUE
    },
    get_env = function(env) {
      Sys.getenv(env)
    },
    is_env = function(env, value) {
      self$get_env(env) == value
    },
    has_env = function(env) {
      self$get_env(env) != ""
    },
    on_ghactions = function() {
      TRUE
    }
  )
)
# nocov end

#' Setup deployment for Travis CI
#'
#' Creates a public-private key pair,
#' adds the public key to the GitHub repository via `github_add_key()`,
#' and stores the private key as an encrypted environment variable in Travis CI
#' via [travis_set_var()],
#' possibly in a different repository.
#' The \pkg{tic} companion package contains facilities for installing such a key
#' during a Travis CI build.
#'
#' @param path `[string]` \cr
#'   The path to the repository.
#' @param key_name_private `[string]`\cr
#'   The name of the private key of the SSH key pair which will be created.
#'   If not supplied, `"TIC_DEPLOY_KEY"` will be used.
#' @param key_name_public `[string]`\cr
#'   The name of the private key of the SSH key pair which will be created.
#'   If not supplied, `"Deploy key for Github Actions"` will be used.
#'
#' @export
use_ghactions_deploy <- function(path = usethis::proj_get(),
                                 repo = travis::get_repo_slug(remote),
                                 key_name_private = "TIC_DEPLOY_KEY",
                                 key_name_public = "Deploy key for Github Actions",
                                 remote = "origin",
                                 quiet = FALSE) {

  requireNamespace("sodium", quietly = TRUE)
  requireNamespace("gh", quietly = TRUE)

  travis::auth_github()

  # generate deploy key pair
  key <- openssl::rsa_keygen() # TOOD: num bits?

  # encrypt private key using tempkey and iv
  pub_key <- travis::get_public_key(key)
  private_key <- travis::encode_private_key(key)

  travis::check_private_key_name(key_name_private)

  # Clear old keys on Github deploy key ----------------------------------------

  # query deploy key
  if (!quiet) {
    cli::cli_alert_info("Querying Github deploy keys from repo.")
  }
  gh_keys <- gh::gh("/repos/:owner/:repo/keys",
    owner = travis::get_owner(remote),
    repo = travis::get_repo(remote)
  )

  if (!gh_keys[1] == "") {
    gh_keys_names <- gh_keys %>%
      purrr::map_chr(~ .x$title)
  }

  # check if key(s) exist ------------------------------------------------------

  # Github (public key)
  if (!gh_keys[1] == "") {
    public_key_exists <- any(gh_keys_names %in% key_name_public)
  } else {
    public_key_exists <- FALSE
  }

  secrets <- gh::gh("/repos/:owner/:repo/actions/secrets",
    owner = travis::get_owner(remote),
    repo = travis::get_repo(remote)
  )

  if (secrets$total_count >= 1) {
    private_key_exists <- TRUE
  } else {
    private_key_exists <- FALSE
  }

  if (private_key_exists && public_key_exists) {
    cli::cli_alert("Deploy keys for Github Actions already present.
                   No action required.", wrap = TRUE)
    return(invisible("Deploy keys already present."))
  } else if (private_key_exists | public_key_exists ||
    !private_key_exists && !public_key_exists) {
    cli::cli_alert("At least one key part is missing (private or public).
                    Deleting old keys and adding new Github Actions deploy keys
                    for repo {travis::get_owner(remote)}/{travis::get_repo()}",
                   wrap = TRUE)
    cli::rule()
  } else if (!private_key_exists && !public_key_exists) {
    cli::cli_alert("Adding Deploy keys for repo
                   {travis::get_owner(remote)}/{travis::get_repo()}",
                   wrap = TRUE)
    cli::rule()
  }

  # delete and set new keys since at least one is missing ----------------------

  if (public_key_exists) {
    cli::cli_alert("Clearing old public key on Github because its counterpart
                    (private key) is most likely missing on Github Actions.")
    # delete existing public key from github
    key_id <- which(gh_keys_names %>%
      purrr::map_lgl(~ .x == key_name_public))
    gh::gh("DELETE /repos/:owner/:repo/keys/:key_id",
      owner = travis::get_owner(remote),
      repo = travis::get_repo(remote),
      key_id = gh_keys[[key_id]]$id
    )
  }

  # add public key
  travis::github_add_key(
    pubkey = pub_key,
    user = travis::get_user(),
    repo = travis::get_repo(remote),
    title = key_name_public
  )

  # delete private key if it exists
  if (private_key_exists) {
    gh::gh("DELETE /repos/:owner/:repo/actions/secrets/:name",
      owner = travis::get_owner(remote),
      repo = travis::get_repo(remote),
      name = key_name_private
    )
  }

  # we need to get the key_id of the users PAT
  # https://developer.github.com/v3/actions/secrets/#get-your-public-key
  key_id <- gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
    owner = travis::get_owner(remote),
    repo = travis::get_repo(remote)
  )$key_id


  pub_key_gh = gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
                      owner = travis::get_owner(remote),
                      repo = travis::get_repo(remote)
  )$key

  # convert to raw for sodium
  private_key_raw <- charToRaw(private_key)
  # decode public key
  pub_key_gh_dec <- base64enc::base64decode(pub_key_gh)
  # encrypt using the pub key
  private_key_encr <- sodium::simple_encrypt(private_key_raw, pub_key_gh_dec)
  # base64 encode secret
  private_key_encr <- base64enc::base64encode(private_key_encr)

  # add private key
  gh::gh("PUT /repos/:owner/:repo/actions/secrets/:name",
    owner = travis::get_owner(remote),
    repo = travis::get_repo(remote),
    name = key_name_private,
    key_id = key_id,
    encrypted_value = private_key_encr
  )

  cli::cat_rule()
  cli::cli_alert_success(
    "Added the private SSH key as secret {.var {key_name_private}} to repository
    {.code {travis::get_owner(remote)}/{travis::get_repo()}}.",
    wrap = TRUE
  )
  cli::cli_alert_success(
    "Added the public SSH key as a deploy key to project
    {.code {travis::get_owner(remote)}/{travis::get_repo()}} on Github.",
    wrap = TRUE
  )
}
