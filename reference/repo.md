# Shortcuts for accessing CRAN-like repositories

These functions can be used as convenient shortcuts for the `repos`
argument to e.g.
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md)
and
[`step_install_deps()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md).

`repo_default()` returns the value of the `"repos"` option, or
`repo_cloud()` if the option is not set.

`repo_cloud()` returns RStudio's CRAN mirror.

`repo_cran()` returns the master CRAN repo.

`repo_bioc()` returns Bioconductor repos from
[`remotes::bioc_install_repos()`](https://remotes.r-lib.org/reference/bioc_install_repos.html),
in addition to the default repo.

## Usage

``` r
repo_default()

repo_cloud()

repo_cran()

repo_bioc(base = repo_default())
```

## Arguments

- base:

  The base repo to use, defaults to `repo_default()`. Pass `NULL` to
  install only from Bioconductor repos.
