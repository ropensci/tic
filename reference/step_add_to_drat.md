# Step: Add built package to a drat

Builds a package (binary on OS X or Windows) and inserts it into an
existing drat repository via
[`drat::insertPackage()`](https://rdrr.io/pkg/drat/man/insertPackage.html).

## Usage

``` r
step_add_to_drat(repo_slug = NULL, deploy_dev = FALSE)
```

## Arguments

- repo_slug:

  `[string]`  
  The name of the drat repository to deploy to in the form
  `:owner/:repo`.

- deploy_dev:

  `[logical]`  
  Should development versions of packages also be deployed to the drat
  repo? By default only "major", "minor" and "patch" releases are build
  and deployed.

## See also

Other steps:
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md),
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md),
[`step_install_pkg`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md),
[`step_install_ssh_keys()`](https://docs.ropensci.org/tic/dev/reference/step_install_ssh_keys.md),
[`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md),
[`step_run_code()`](https://docs.ropensci.org/tic/dev/reference/step_run_code.md),
[`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md),
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md),
[`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md),
[`step_test_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_test_ssh.md),
[`step_write_text_file()`](https://docs.ropensci.org/tic/dev/reference/step_write_text_file.md)

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("script") %>%
  add_step(step_add_to_drat())
#> Superclass TicStep has cloneable=FALSE, but subclass AddToDrat has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for AddToDrat.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_add_to_drat()
```
