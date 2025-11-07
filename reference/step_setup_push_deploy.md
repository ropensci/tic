# Step: Setup push deploy

Clones a repo, inits author information, and sets up remotes for a
subsequent
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md).

## Usage

``` r
step_setup_push_deploy(
  path = ".",
  branch = NULL,
  orphan = FALSE,
  remote_url = NULL,
  checkout = TRUE
)
```

## Arguments

- path:

  `[string]`  
  Path to the repository, default `"."` which means setting up the
  current repository.

- branch:

  `[string]`  
  Target branch, default: current branch.

- orphan:

  `[flag]`  
  Create and force-push an orphan branch consisting of only one commit?
  This can be useful e.g. for `path = "docs", branch = "gh-pages"`, but
  cannot be applied for pushing to the current branch.

- remote_url:

  `[string]`  
  The URL of the remote Git repository to push to, defaults to the
  current GitHub repository.

- checkout:

  `[flag]`  
  Check out the current contents of the repository? Defaults to `TRUE`,
  set to `FALSE` if the build process relies on existing contents or if
  you deploy to a different branch.

## See also

Other deploy steps:
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md)

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
[`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md),
[`step_test_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_test_ssh.md),
[`step_write_text_file()`](https://docs.ropensci.org/tic/dev/reference/step_write_text_file.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dsl_init()

get_stage("deploy") %>%
  add_step(step_setup_push_deploy(path = "docs", branch = "gh-pages")) %>%
  add_step(step_build_pkgdown())

# This example needs a Git repository
if (rlang::is_installed("git2r") && git2r::in_repository()) {
  # Deployment only works if a companion step_do_push_deploy() is added
  get_stage("deploy") %>%
    add_step(step_do_push_deploy(path = "docs"))
}

dsl_get()
} # }
```
