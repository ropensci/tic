# Add a tic.R file to the repo

Adds a `tic.R` file to containing the macros/steps/stages to be run
during CI runs.

The content depends on the repo type (detected automatically when used
within
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)).

## Usage

``` r
use_tic_r(repo_type, deploy_on = "none")
```

## Arguments

- repo_type:

  (`character(1)`)  
  Which type of template should be used. Possible values are
  `"package"`, `"site"`, `"blogdown"`, `"bookdown"` or `"unknown"`.

- deploy_on:

  (`character(1)`)  
  Which CI provider should perform deployment? Defaults to `NULL` which
  means no deployment will be done. Possible values are `"ghactions"` or
  `"circle"`.

## See also

[yaml_templates](https://docs.ropensci.org/tic/dev/reference/yaml_templates.md),
[`use_tic_badge()`](https://docs.ropensci.org/tic/dev/reference/use_tic_badge.md)

## Examples

``` r
if (FALSE) { # \dontrun{
use_tic_r("package")
use_tic_r("package", deploy_on = "ghactions")
use_tic_r("blogdown", deploy_on = "all")
} # }
```
