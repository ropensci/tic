# Setup deployment for GitHub Actions

**\[experimental\]**

Creates a public-private key pair, adds the public key to the GitHub
repository via
[`github_add_key()`](https://docs.ropensci.org/tic/dev/reference/ssh_key_helpers.md),
and stores the private key as a "secret" in the GitHub repo.

## Usage

``` r
use_ghactions_deploy(
  path = usethis::proj_get(),
  repo = get_repo_slug(remote),
  key_name_private = "TIC_DEPLOY_KEY",
  key_name_public = "Deploy key for GitHub Actions",
  remote = "origin"
)
```

## Arguments

- path:

  `[string]`  
  The path to the repository.

- repo:

  `[string]`  
  The repository slug to use. Must follow the "`user/repo`" structure.

- key_name_private:

  `[string]`  
  The name of the private key of the SSH key pair which will be created.
  If not supplied, `"TIC_DEPLOY_KEY"` will be used.

- key_name_public:

  `[string]`  
  The name of the private key of the SSH key pair which will be created.
  If not supplied, `"Deploy key for GitHub Actions"` will be used.

- remote:

  `[string]`  
  The GitHub remote which should be used. Defaults to "origin".
