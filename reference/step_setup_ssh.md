# Step: Setup SSH

Adds to known hosts, installs private key, and tests the connection.
Chaining
[`step_install_ssh_keys()`](https://docs.ropensci.org/tic/dev/reference/step_install_ssh_keys.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md)
and
[`step_test_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_test_ssh.md).
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)
encodes a private key as an environment variable for use with this
function.

## Usage

``` r
step_setup_ssh(
  private_key_name = "TIC_DEPLOY_KEY",
  host = "github.com",
  url = paste0("git@", host),
  verbose = ""
)
```

## Arguments

- private_key_name:

  `string`  
  Only needed when deploying from builds on GitHub Actions. If you have
  set a custom name for the private key during creation of the SSH key
  pair via tic::use_ghactions_deploy()\] or
  [`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md),
  pass this name here.

- host:

  `[string]`  
  The host name to add to the `known_hosts` file, default: `github.com`.

- url:

  `[string]`  
  URL to establish SSH connection with, by default `git@github.com`

- verbose:

  `[string]`  
  Verbosity, by default `""`. Use `-v` or `"-vvv"` for more verbosity.

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
[`step_run_code()`](https://docs.ropensci.org/tic/dev/reference/step_run_code.md),
[`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md),
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md),
[`step_test_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_test_ssh.md),
[`step_write_text_file()`](https://docs.ropensci.org/tic/dev/reference/step_write_text_file.md)

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("script") %>%
  add_step(step_setup_ssh(host = "gitlab.com"))
#> Superclass TicStep has cloneable=FALSE, but subclass SetupSSH has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for SetupSSH.
#> Superclass TicStep has cloneable=FALSE, but subclass InstallSSHKeys has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for InstallSSHKeys.
#> Superclass TicStep has cloneable=FALSE, but subclass AddToKnownHosts has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for AddToKnownHosts.
#> Superclass TicStep has cloneable=FALSE, but subclass TestSSH has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for TestSSH.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_setup_ssh(host="gitlab.com")
```
