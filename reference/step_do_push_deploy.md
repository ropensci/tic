# Step: Perform push deploy

Commits and pushes to a repo prepared by
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md).

Deployment usually requires setting up SSH keys with
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md).

## Usage

``` r
step_do_push_deploy(
  path = ".",
  commit_message = NULL,
  commit_paths = ".",
  force = FALSE
)
```

## Arguments

- path:

  `[string]`  
  Path to the repository, default `"."` which means setting up the
  current repository.

- commit_message:

  `[string]`  
  Commit message to use, defaults to a useful message linking to the CI
  build and avoiding recursive CI runs.

- commit_paths:

  `[character]`  
  Restrict the set of directories and/or files added to Git before
  deploying. Default: deploy all files.

- force:

  `[logical]`  
  Add `--force` flag to git commands?

## Details

It is highly recommended to restrict the set of files touched by the
deployment with the `commit_paths` argument: this step assumes that it
can freely overwrite all changes to all files below `commit_paths`, and
will not warn in case of conflicts.

To mitigate conflicts race conditions to the greatest extent possible,
the following strategy is used:

- The changes are committed to the branch

- Before pushing, new commits are fetched, and the changes are
  cherry-picked on top of the new commits

If no new commits were pushed after the CI run has started, this
strategy is equivalent to committing and pushing. In the opposite case,
if the remote repo has new commits, the deployment is safely applied to
the current tip.

## See also

Other deploy steps:
[`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md),
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md),
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
if (FALSE) { # \dontrun{
dsl_init()

# Deployment only works if a companion step_setup_push_deploy() is added
get_stage("deploy") %>%
  add_step(step_setup_push_deploy(path = "docs", branch = "gh-pages")) %>%
  add_step(step_build_pkgdown())

if (rlang::is_installed("git2r") && git2r::in_repository()) {
  get_stage("deploy") %>%
    add_step(step_do_push_deploy(path = "docs"))
}

dsl_get()
} # }
```
