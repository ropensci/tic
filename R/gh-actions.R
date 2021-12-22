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
      # https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables # nolint
      return("")
    },
    is_tag = function() {
      self$get_tag() == "true"
    },
    get_slug = function() {
      Sys.getenv("GITHUB_REPOSITORY")
    },
    get_build_number = function() {
      paste0("Github Actions build ", self$get_env("GITHUB_RUN_ID"))
    },
    get_build_url = function() {
      paste0(
        "https://github.com/", self$get_slug(), "/actions/runs/",
        self$get_env("GITHUB_RUN_ID")
      )
    },
    get_commit = function() {
      Sys.getenv("GITHUB_SHA")
    },
    can_push = function(private_key_name = "TIC_DEPLOY_KEY") {
      # id_rsa is the "old" name which was previously hard coded.
      # New default name: "TIC_DEPLOY_KEY"
      # for backward comp we check for the old one too
      private_key_name <- compat_ssh_key(private_key_name)
      self$has_env(private_key_name)
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

#' @title Add a GitHub Actions secret to a repository
#' @description Encrypts the supplied value using `libsodium` and adds it as a
#' secret to the given GitHub repository. Secrets can be be used in GitHub
#' Action runs as environment variables.
#' A common use case is to encrypt Personal Access Tokens (PAT) or API keys.
#'
#' This is the same as adding a secret manually in GitHub via
#' `"Settings" -> "Secrets" -> "New repository secret"`
#'
#' @param secret `[character]`\cr
#'   The value which should be encrypted (e.g. a Personal Access Token).
#'
#' @param name `[character]`\cr
#'   The name of the secret as which it will appear in the "Secrets" overview of
#'   the repository.
#'
#' @param visibility `[character]`\cr
#'   The level of visibility for the secret. One of `"all"`, `"private"`, or
#'   `"selected"`.
#'   See https://developer.github.com/v3/actions/secrets/#create-or-update-an-organization-secret
#'   for more information.
#' @param selected_repositories `[character]`\cr
#'   Vector of repository ids for which the secret is accessible.
#'   Only applies if `visibility = "selected"` was set.
#' @param repo_slug `[character]`\cr
#'   Repository slug of the repository to which the secret should be added.
#'   Must follow the form `owner/repo`.
#' @param remote `[character]`\cr
#'   If `repo_slug = NULL`, the `repo_slug` is determined by the respective git
#'   remote.
#' @examples
#' \dontrun{
#' gha_add_secret("supersecret", name = "MY_SECRET", repo = "ropensci/tic")
#' }
#'
#' @export
gha_add_secret <- function(secret,
                           name,
                           repo_slug = NULL,
                           remote = "origin",
                           visibility = "all",
                           selected_repositories = NULL) {
  requireNamespace("sodium", quietly = TRUE)
  requireNamespace("gh", quietly = TRUE)

  if (is.null(repo_slug)) {
    owner <- get_owner(remote)
    repo <- get_repo(remote)
    repo_slug <- paste(get_owner(remote), "/", get_repo(remote))
  } else {
    slug <- strsplit(repo_slug, "/")[[1]]
    owner <- slug[1]
    repo <- slug[2]
  }

  auth_github()

  key_id <- gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
    owner = owner,
    repo = repo
  )$key_id

  pub_key_gh <- gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
    owner = owner,
    repo = repo
  )$key

  key_id <- gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
    owner = owner,
    repo = repo
  )$key_id

  # convert to raw for sodium
  secret_raw <- charToRaw(secret)
  # decode public key
  pub_key_gh_dec <- base64enc::base64decode(pub_key_gh)
  # encrypt using the pub key
  secret_raw_encr <- sodium::simple_encrypt(secret_raw, pub_key_gh_dec)
  # base64 encode secret
  secret_raw_encr <- base64enc::base64encode(secret_raw_encr)

  # add private key
  gh::gh("PUT /repos/:owner/:repo/actions/secrets/:secret_name",
    owner = owner,
    repo = repo,
    secret_name = name,
    key_id = key_id,
    encrypted_value = secret_raw_encr,
    visibility = visibility,
    selected_repository_ids = selected_repositories
  )

  cli::cli_alert_success("Successfully added secret {.env {name}} to repo
   {.field {owner}/{repo}}.", wrap = TRUE)
}

#' Setup deployment for GitHub Actions
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Creates a public-private key pair, adds the public key to the GitHub
#' repository via `github_add_key()`, and stores the private key as a "secret"
#' in the GitHub repo.
#'
#' @param path `[string]` \cr
#'   The path to the repository.
#' @param repo `[string]`\cr
#'   The repository slug to use. Must follow the "`user/repo`" structure.
#' @param key_name_private `[string]`\cr
#'   The name of the private key of the SSH key pair which will be created.
#'   If not supplied, `"TIC_DEPLOY_KEY"` will be used.
#' @param key_name_public `[string]`\cr
#'   The name of the private key of the SSH key pair which will be created.
#'   If not supplied, `"Deploy key for GitHub Actions"` will be used.
#' @param remote `[string]`\cr
#'   The GitHub remote which should be used. Defaults to "origin".
#' @export
use_ghactions_deploy <- function(path = usethis::proj_get(),
                                 repo = get_repo_slug(remote),
                                 key_name_private = "TIC_DEPLOY_KEY",
                                 key_name_public = "Deploy key for GitHub Actions", # nolint
                                 remote = "origin") {
  requireNamespace("sodium", quietly = TRUE)
  requireNamespace("gh", quietly = TRUE)
  requireNamespace("purrr", quietly = TRUE)

  auth_github()

  # generate deploy key pair
  key <- openssl::rsa_keygen() # TOOD: num bits?

  # encrypt private key using tempkey and iv
  pub_key <- get_public_key(key)
  private_key <- encode_private_key(key)

  check_private_key_name(key_name_private)

  # Clear old keys on GitHub deploy key ----------------------------------------

  # query deploy key
  cli::cli_alert_info("Querying GitHub deploy keys from repo.")
  gh_keys <- gh::gh("/repos/:owner/:repo/keys",
    owner = get_owner(remote),
    repo = get_repo(remote)
  )

  if (!gh_keys[1] == "") {
    gh_keys_names <- gh_keys %>%
      purrr::map_chr(~ .x$title)
  }

  # check if key(s) exist ------------------------------------------------------

  # GitHub (public key)
  if (!gh_keys[1] == "") {
    public_key_exists <- any(gh_keys_names %in% key_name_public)
  } else {
    public_key_exists <- FALSE
  }

  secrets <- gh::gh("/repos/:owner/:repo/actions/secrets",
    owner = get_owner(remote),
    repo = get_repo(remote)
  )

  secret_names <- purrr::map_chr(secrets$secrets, "name")

  if (key_name_private %in% secret_names) {
    private_key_exists <- TRUE
  } else {
    private_key_exists <- FALSE
  }

  if (private_key_exists && public_key_exists) {
    cli::cli_alert("Deploy keys for GitHub Actions already present.
                   No action required.", wrap = TRUE)
    return(invisible("Deploy keys already present."))
  } else if (private_key_exists || public_key_exists ||
    !private_key_exists && !public_key_exists) {
    cli::cli_alert("At least one key part is missing (private or public).
      Deleting old keys and adding new GitHub Actions deploy keys
      for repo {get_owner(remote)}/{get_repo(remote)}",
      wrap = TRUE
    )
    cli::rule()
  } else if (!private_key_exists && !public_key_exists) {
    cli::cli_alert("Adding Deploy keys for repo
                   {get_owner(remote)}/{get_repo(remote)}",
      wrap = TRUE
    )
    cli::rule()
  }

  # delete and set new keys since at least one is missing ----------------------

  if (public_key_exists) {
    cli::cli_alert("Clearing old public key on GitHub because its counterpart
                    (private key) is most likely missing on GitHub Actions.")
    # delete existing public key from github
    key_id <- which(gh_keys_names %>%
      purrr::map_lgl(~ .x == key_name_public))
    gh::gh("DELETE /repos/:owner/:repo/keys/:key_id",
      owner = get_owner(remote),
      repo = get_repo(remote),
      key_id = gh_keys[[key_id]]$id
    )
  }

  # add public key
  github_add_key(
    pubkey = pub_key,
    user = get_user(),
    repo = get_repo(remote),
    title = key_name_public,
    remote = remote
  )

  # delete private key if it exists
  if (private_key_exists) {
    gh::gh("DELETE /repos/:owner/:repo/actions/secrets/:name",
      owner = get_owner(remote),
      repo = get_repo(remote),
      name = key_name_private
    )
  }

  # we need to get the key_id of the users PAT
  # https://developer.github.com/v3/actions/secrets/#get-your-public-key
  key_id <- gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
    owner = get_owner(remote),
    repo = get_repo(remote)
  )$key_id


  pub_key_gh <- gh::gh("GET /repos/:owner/:repo/actions/secrets/public-key",
    owner = get_owner(remote),
    repo = get_repo(remote)
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
    owner = get_owner(remote),
    repo = get_repo(remote),
    name = key_name_private,
    key_id = key_id,
    encrypted_value = private_key_encr
  )

  cli::cat_rule()
  cli::cli_alert_success(
    "Added the private SSH key as secret {.var {key_name_private}} to repository
    {.code {get_owner(remote)}/{get_repo(remote)}}.",
    wrap = TRUE
  )
  cli::cli_alert_success(
    "Added the public SSH key as a deploy key to project
    {.code {get_owner(remote)}/{get_repo(remote)}} on GitHub.",
    wrap = TRUE
  )
}
