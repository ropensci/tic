# Add a GitHub Actions secret to a repository

Encrypts the supplied value using `libsodium` and adds it as a secret to
the given GitHub repository. Secrets can be be used in GitHub Action
runs as environment variables. A common use case is to encrypt Personal
Access Tokens (PAT) or API keys.

This is the same as adding a secret manually in GitHub via
`"Settings" -> "Secrets" -> "New repository secret"`

## Usage

``` r
gha_add_secret(
  secret,
  name,
  repo_slug = NULL,
  remote = "origin",
  visibility = "all",
  selected_repositories = NULL
)
```

## Arguments

- secret:

  `[character]`  
  The value which should be encrypted (e.g. a Personal Access Token).

- name:

  `[character]`  
  The name of the secret as which it will appear in the "Secrets"
  overview of the repository.

- repo_slug:

  `[character]`  
  Repository slug of the repository to which the secret should be added.
  Must follow the form `owner/repo`.

- remote:

  `[character]`  
  If `repo_slug = NULL`, the `repo_slug` is determined by the respective
  git remote.

- visibility:

  `[character]`  
  The level of visibility for the secret. One of `"all"`, `"private"`,
  or `"selected"`. See
  https://developer.github.com/v3/actions/secrets/#create-or-update-an-organization-secret
  for more information.

- selected_repositories:

  `[character]`  
  Vector of repository ids for which the secret is accessible. Only
  applies if `visibility = "selected"` was set.

## Examples

``` r
if (FALSE) { # \dontrun{
gha_add_secret("supersecret", name = "MY_SECRET", repo = "ropensci/tic")
} # }
```
