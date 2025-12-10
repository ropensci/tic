# Deprecated functions

`add_package_checks()` has been replaced by
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md).

## Usage

``` r
add_package_checks(
  ...,
  warnings_are_errors = NULL,
  notes_are_errors = NULL,
  args = c("--no-manual", "--as-cran"),
  build_args = "--force",
  error_on = "warning",
  repos = repo_default(),
  timeout = Inf
)
```

## Arguments

- ...:

  Ignored, used to enforce naming of arguments.

- warnings_are_errors, notes_are_errors:

  `[flag]`  
  Deprecated, use `error_on`.

- args:

  `[character]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md).  

  Default for local runs: `c("--no-manual", "--as-cran")`.

  Default for Windows:
  `c("--no-manual", "--as-cran", "--no-vignettes", "--no-build-vignettes", "--no-multiarch")`.

  On GitHub Actions option "–no-manual" is always used (appended to
  custom user input) because LaTeX is not available and installation is
  time consuming and error prone.  

- build_args:

  `[character]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md).  
  Default for local runs: `"--force"`.  
  Default for Windows: `c("--no-build-vignettes", "--force")`.  

- error_on:

  `[character]`  
  Whether to throw an error on R CMD check failures. Note that the check
  is always completed (unless a timeout happens), and the error is only
  thrown after completion. If "never", then no errors are thrown. If
  "error", then only ERROR failures generate errors. If "warning", then
  WARNING failures generate errors as well. If "note", then any check
  failure generated an error.

- repos:

  `[character]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md),
  default:
  [`repo_default()`](https://docs.ropensci.org/tic/dev/reference/repo.md).

- timeout:

  `[numeric]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md),
  default: `Inf`.
