# Step: Check a package

Check a package using
[`rcmdcheck::rcmdcheck()`](http://r-lib.github.io/rcmdcheck/reference/rcmdcheck.md),
which ultimately calls `R CMD check`.

## Usage

``` r
step_rcmdcheck(
  ...,
  warnings_are_errors = NULL,
  notes_are_errors = NULL,
  args = NULL,
  build_args = NULL,
  error_on = "warning",
  repos = repo_default(),
  timeout = Inf,
  check_dir = "check"
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

- check_dir:

  `[character]`  
  Path specifying the directory for R CMD check. Defaults to `"check"`
  for easy upload of artifacts.

## Updating of (dependency) packages

Packages shipped with the R-installation will not be updated as they
will be overwritten by the R-installer in each build. If you want these
package to be updated, please add the following step to your workflow:
`add_code_step(remotes::update_packages("<pkg>"))`.

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("script") %>%
  add_step(step_rcmdcheck(error_on = "note", repos = repo_bioc()))
#> Superclass TicStep has cloneable=FALSE, but subclass RCMDcheck has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for RCMDcheck.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_rcmdcheck(error_on="note", repos=repo_bioc())
```
