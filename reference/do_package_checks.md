# Add default checks for packages

`do_package_checks()` adds default steps related to package checks to
the `"before_install"`, `"install"`, `"script"` and `"after_success"`
stages:

This macro is only available for R packages.

1.  [`step_install_deps()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md)
    in the `"install"` stage, using the `repos` argument.

2.  [`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md)
    in the `"install"` stage.

3.  [`step_rcmdcheck()`](https://docs.ropensci.org/tic/dev/reference/step_rcmdcheck.md)
    in the `"script"` stage, using the `warnings_are_errors`,
    `notes_are_errors`, `args`, and `build_args` arguments.

4.  A call to
    [`covr::codecov()`](https://rdrr.io/pkg/covr/man/codecov.html) in
    the `"after_success"` stage (only if the `codecov` flag is set)

## Usage

``` r
do_package_checks(
  ...,
  codecov = !ci_is_interactive(),
  warnings_are_errors = NULL,
  notes_are_errors = NULL,
  args = NULL,
  build_args = NULL,
  error_on = "warning",
  repos = repo_default(),
  dependencies = TRUE,
  timeout = Inf,
  check_dir = "check"
)
```

## Arguments

- ...:

  Ignored, used to enforce naming of arguments.

- codecov:

  `[flag]`  
  Whether to include a step running `covr::codecov(quiet = FALSE)`
  (default: only for non-interactive CI, see
  [`ci_is_interactive()`](https://docs.ropensci.org/tic/dev/reference/ci.md)).

- warnings_are_errors, notes_are_errors:

  `[flag]`  
  Deprecated, use `error_on`.

- args:

  `[character]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](https://rdrr.io/pkg/rcmdcheck/man/rcmdcheck.html).  

  Default for local runs: `c("--no-manual", "--as-cran")`.

  Default for Windows:
  `c("--no-manual", "--as-cran", "--no-vignettes", "--no-build-vignettes", "--no-multiarch")`.

  On GitHub Actions option "–no-manual" is always used (appended to
  custom user input) because LaTeX is not available and installation is
  time consuming and error prone.  

- build_args:

  `[character]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](https://rdrr.io/pkg/rcmdcheck/man/rcmdcheck.html).  
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
  [`rcmdcheck::rcmdcheck()`](https://rdrr.io/pkg/rcmdcheck/man/rcmdcheck.html),
  default:
  [`repo_default()`](https://docs.ropensci.org/tic/dev/reference/repo.md).

- dependencies:

  What kinds of dependencies to install. Most commonly one of the
  following values:

  - `NA`: only required (hard) dependencies,

  - `TRUE`: required dependencies plus optional and development
    dependencies,

  - `FALSE`: do not install any dependencies. (You might end up with a
    non-working package, and/or the installation might fail.) See
    [Package dependency
    types](https://rdrr.io/pkg/pak/man/package-dependency-types.html)
    for other possible values and more information about package
    dependencies.

- timeout:

  `[numeric]`  
  Passed to
  [`rcmdcheck::rcmdcheck()`](https://rdrr.io/pkg/rcmdcheck/man/rcmdcheck.html),
  default: `Inf`.

- check_dir:

  `[character]`  
  Path specifying the directory for R CMD check. Defaults to `"check"`
  for easy upload of artifacts.

## See also

Other macros:
[`do_blogdown()`](https://docs.ropensci.org/tic/dev/reference/do_blogdown.md),
[`do_bookdown()`](https://docs.ropensci.org/tic/dev/reference/do_bookdown.md),
[`do_drat()`](https://docs.ropensci.org/tic/dev/reference/do_drat.md),
[`do_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/do_pkgdown.md),
[`do_readme_rmd()`](https://docs.ropensci.org/tic/dev/reference/do_readme_rmd.md),
[`list_macros()`](https://docs.ropensci.org/tic/dev/reference/list_macros.md)

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

do_package_checks()
#> Superclass TicStep has cloneable=FALSE, but subclass SessionInfo has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for SessionInfo.
#> Superclass TicStep has cloneable=FALSE, but subclass InstallDeps has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for InstallDeps.
#> Superclass TicStep has cloneable=FALSE, but subclass RCMDcheck has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for RCMDcheck.
#> Superclass TicStep has cloneable=FALSE, but subclass RunCode has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for RunCode.
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: install ──────────────────────────────────────────────────────────────
#> ▶ step_install_deps(dependencies=TRUE)
#> ▶ step_session_info()
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_rcmdcheck(warnings_are_errors=NULL, notes_are_errors=NULL, args=NULL, build_args=NULL, error_on="warning", repos=repo_default(), timeout=Inf, check_dir="check")
#> ── Stage: after_success ────────────────────────────────────────────────────────
#> ▶ step_run_code(covr::codecov(quiet=FALSE))

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: install ──────────────────────────────────────────────────────────────
#> ▶ step_install_deps(dependencies=TRUE)
#> ▶ step_session_info()
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_rcmdcheck(warnings_are_errors=NULL, notes_are_errors=NULL, args=NULL, build_args=NULL, error_on="warning", repos=repo_default(), timeout=Inf, check_dir="check")
#> ── Stage: after_success ────────────────────────────────────────────────────────
#> ▶ step_run_code(covr::codecov(quiet=FALSE))
```
