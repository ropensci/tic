# Step: Run arbitrary R code

Captures the expression and executes it when running the step. An
optional preparatory expression can be provided that is executed during
preparation. If the top-level expression is a qualified function call
(of the format `package::fun()`), the package is installed during
preparation.

## Usage

``` r
step_run_code(call = NULL, prepare_call = NULL)
```

## Arguments

- call:

  `[call]`  
  An arbitrary R expression executed during the stage to which this step
  is added. The default is useful if you only pass `prepare_call`.

- prepare_call:

  `[call]`  
  An optional arbitrary R expression executed during preparation.

## See also

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md),
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md),
[`step_install_pkg`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md),
[`step_install_ssh_keys()`](https://docs.ropensci.org/tic/dev/reference/step_install_ssh_keys.md),
[`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md),
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

get_stage("install") %>%
  add_step(step_run_code(update.packages(ask = FALSE)))
#> Superclass TicStep has cloneable=FALSE, but subclass RunCode has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for RunCode.

# Will install covr from CRAN during preparation:
get_stage("after_success") %>%
  add_code_step(covr::codecov())
#> Superclass TicStep has cloneable=FALSE, but subclass RunCode has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for RunCode.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: install ──────────────────────────────────────────────────────────────
#> ▶ step_run_code(update.packages(ask=FALSE))
#> ── Stage: after_success ────────────────────────────────────────────────────────
#> ▶ step_run_code(covr::codecov())
```
