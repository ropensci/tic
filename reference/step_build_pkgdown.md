# Step: Build pkgdown documentation

Builds package documentation with the pkgdown package. Calls
[`pkgdown::clean_site()`](https://pkgdown.r-lib.org/reference/clean.html)
and then `pkgdown::build_site(...)`.

## Usage

``` r
step_build_pkgdown(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`pkgdown::build_site`](https://pkgdown.r-lib.org/reference/build_site.html)

  `pkg`

  :   Path to package.

  `examples`

  :   Run examples?

  `run_dont_run`

  :   Run examples that are surrounded in \dontrun?

  `seed`

  :   Seed used to initialize random number generation in order to make
      article output reproducible. An integer scalar or `NULL` for no
      seed.

  `lazy`

  :   If `TRUE`, will only rebuild articles and reference pages if the
      source is newer than the destination.

  `override`

  :   An optional named list used to temporarily override values in
      `_pkgdown.yml`

  `preview`

  :   If `TRUE`, or `is.na(preview) && interactive()`, will preview
      freshly generated section in browser.

  `devel`

  :   Use development or deployment process?

      If `TRUE`, uses lighter-weight process suitable for rapid
      iteration; it will run examples and vignettes in the current
      process, and will load code with
      [`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html).

      If `FALSE`, will first install the package to a temporary library,
      and will run all examples and vignettes in a new process.

      `build_site()` defaults to `devel = FALSE` so that you get high
      fidelity outputs when you building the complete site;
      `build_reference()`, `build_home()` and friends default to
      `devel = TRUE` so that you can rapidly iterate during development.

  `new_process`

  :   If `TRUE`, will run `build_site()` in a separate process. This
      enhances reproducibility by ensuring nothing that you have loaded
      in the current process affects the build process.

  `install`

  :   If `TRUE`, will install the package in a temporary library so it
      is available for vignettes.

## See also

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
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
  add_step(step_build_pkgdown())
#> Superclass TicStep has cloneable=FALSE, but subclass BuildPkgdown has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for BuildPkgdown.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_build_pkgdown()
```
