# Add a CI Status Badge to README files

Adds a CI status badge to `README.Rmd` or `README.md`. By default the
label is `"tic"`.

A custom branch can be specified via argument `branch`.

## Usage

``` r
use_tic_badge(provider, branch = NULL, label = "tic")
```

## Arguments

- provider:

  `character(1)`  
  The CI provider to generate a badge for. Only `ghactions` is currently
  supported

- branch:

  `character(1)`  
  Which branch should the badge represent? Defaults to the default repo
  branch.

- label:

  `character(1)`  
  Text to use for the badge.

## Examples

``` r
if (FALSE) { # \dontrun{
use_tic_badge(provider = "ghactions")

# use a different branch
use_tic_badge(provider = "ghactions", branch = "develop")
} # }
```
