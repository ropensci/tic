# Step: Install an SSH key

Writes a private SSH key encoded in an environment variable to a file in
`~/.ssh`. Only run in non-interactive settings and if the environment
variable exists and is non-empty.
[`use_ghactions_deploy()`](https://docs.ropensci.org/tic/dev/reference/use_ghactions_deploy.md)
and
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)
functions encode a private key as an environment variable for use with
this function.

## Usage

``` r
step_install_ssh_keys(private_key_name = "TIC_DEPLOY_KEY")
```

## Arguments

- private_key_name:

  `string`  
  Only needed when deploying from builds on GitHub Actions. If you have
  set a custom name for the private key during creation of the SSH key
  pair via tic::use_ghactions_deploy()\] or
  [`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md),
  pass this name here.

## See also

[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md),
[`use_ghactions_deploy()`](https://docs.ropensci.org/tic/dev/reference/use_ghactions_deploy.md)

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md),
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md),
[`step_install_pkg`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md),
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

get_stage("before_deploy") %>%
  add_step(step_install_ssh_keys())
#> Superclass TicStep has cloneable=FALSE, but subclass InstallSSHKeys has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for InstallSSHKeys.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: before_deploy ────────────────────────────────────────────────────────
#> ▶ step_install_ssh_keys()
```
