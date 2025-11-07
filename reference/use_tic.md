# Initialize CI testing using tic

Prepares a repo for building and deploying supported by tic.

## Usage

``` r
use_tic(
  wizard = interactive(),
  linux = "ghactions",
  mac = "ghactions",
  windows = "ghactions",
  deploy = "ghactions",
  matrix = "none",
  private_key_name = "TIC_DEPLOY_KEY",
  quiet = FALSE
)
```

## Arguments

- wizard:

  `[flag]`  
  Interactive operation? If `TRUE`, a menu will be shown.

- linux:

  `[string]`  
  Which CI provider(s) to use to test on Linux. Possible options are
  `"circle"`, `"ghactions"`, `"none"`/`NULL` and `"all"`.

- mac:

  `[string]`  
  Which CI provider(s) to use to test on macOS Possible options are
  `"none"`/`NULL` and `"ghactions"`.

- windows:

  `[string]`  
  Which CI provider(s) to use to test on Windows Possible options are
  `"none"`/`NULL`, and `"ghactions"`.

- deploy:

  `[string]`  
  Which CI provider(s) to use to deploy artifacts such as pkgdown
  documentation. Possible options are
  "circle"`, `"ghactions"`, `"none"`/`NULL`and`"all"\`.

- matrix:

  `[string]`  
  For which CI provider(s) to set up matrix builds. Possible options are
  `"circle"`, `"ghactions"`, `"none"`/`NULL` and `"all"`.

- private_key_name:

  `string`  
  Only needed when deploying from builds on GitHub Actions. If you have
  set a custom name for the private key during creation of the SSH key
  pair via tic::use_ghactions_deploy()\] or `use_tic()`, pass this name
  here.

- quiet:

  `[flag]`  
  Less verbose output? Default: `FALSE`.

## Details

1.  Query information which CI providers should be used

2.  Setup permissions for providers selected for deployment

3.  Create YAML files for selected providers

4.  Create a default `tic.R` file depending on the repo type (package,
    website, bookdown, ...)

## Examples

``` r
# Requires interactive mode
if (FALSE) {
  use_tic()

  # Pre-specified settings favoring Circle CI:
  use_tic(
    wizard = FALSE,
    linux = "circle",
    mac = "ghactions",
    windows = "ghactions",
    deploy = "circle",
    matrix = "all"
  )
}
```
