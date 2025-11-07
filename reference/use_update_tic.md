# Update tic Templates

Adds a GitHub Actions workflow (`update-tic.yml`) to check for tic
template updates once a day.

Internally,
[`update_yml()`](https://docs.ropensci.org/tic/dev/reference/update_yml.md)
is called. A Pull Request will be opened if a newer upstream version of
the local tic template is found.

This workflow relies on a GITHUB_PAT with "workflow" scopes if GitHub
Actions templates should be updated. Generate a GITHUB PAT and add it as
a secret to your repo with
[`gha_add_secret()`](https://docs.ropensci.org/tic/dev/reference/gha_add_secret.md).

## Usage

``` r
use_update_tic()
```

## Examples

``` r
if (FALSE) { # \dontrun{
use_update_tic()
} # }
```
