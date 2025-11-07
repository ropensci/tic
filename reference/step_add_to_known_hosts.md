# Step: Add to known hosts

Adds a host name to the `~/.ssh/known_hosts` file to allow subsequent
SSH access. Requires `ssh-keyscan` on the system `PATH`.

## Usage

``` r
step_add_to_known_hosts(host = "github.com")
```

## Arguments

- host:

  `[string]`  
  The host name to add to the `known_hosts` file, default: `github.com`.

## See also

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
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

get_stage("before_deploy") %>%
  add_step(step_add_to_known_hosts("gitlab.com"))
#> Superclass TicStep has cloneable=FALSE, but subclass AddToKnownHosts has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for AddToKnownHosts.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: before_deploy ────────────────────────────────────────────────────────
#> ▶ step_add_to_known_hosts("gitlab.com")
```
