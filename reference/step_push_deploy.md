# Step: Setup and perform push deploy

Clones a repo, initializes author information, sets up remotes, commits,
and pushes. Combines
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
with `checkout = FALSE` and a suitable `orphan` argument, and
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md).

Deployment usually requires setting up SSH keys with
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md).

## Usage

``` r
step_push_deploy(
  path = ".",
  branch = NULL,
  remote_url = NULL,
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

- branch:

  `[string]`  
  Target branch, default: current branch.

- remote_url:

  `[string]`  
  The URL of the remote Git repository to push to, defaults to the
  current GitHub repository.

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

Setup and deployment are combined in one step, the files to be deployed
must be prepared in a previous step. This poses some restrictions on how
the repository can be initialized, in particular for a nonstandard
`path` argument only `orphan = TRUE` can be supported (and will be
used).

For more control, create two separate steps with
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
and
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
and create the files to be deployed in between these steps.

## See also

Other deploy steps:
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md),
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md),
[`step_install_pkg`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md),
[`step_install_ssh_keys()`](https://docs.ropensci.org/tic/dev/reference/step_install_ssh_keys.md),
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

get_stage("script") %>%
  add_step(step_push_deploy(commit_paths = c("NAMESPACE", "man")))

dsl_get()
} # }
```
