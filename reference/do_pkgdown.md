# Build pkgdown documentation

`do_pkgdown()` builds and optionally deploys a pkgdown site and adds
default steps to the `"install"`, `"before_deploy"` and `"deploy"`
stages:

1.  [`step_install_deps()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md)
    in the `"install"` stage

2.  [`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md)
    in the `"install"` stage.

3.  [`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md)
    in the `"before_deploy"` to setup the upcoming deployment (if
    `deploy` is set and only on GitHub Actions),

4.  [`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
    in the `"before_deploy"` stage (if `deploy` is set),

5.  [`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md)
    in the `"deploy"` stage, forwarding all `...` arguments.

6.  [`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md)
    in the `"deploy"` stage.

By default, the `docs/` directory is deployed to the `gh-pages` branch,
keeping the history.

## Usage

``` r
do_pkgdown(
  ...,
  deploy = NULL,
  orphan = FALSE,
  checkout = TRUE,
  path = "docs",
  branch = "gh-pages",
  remote_url = NULL,
  commit_message = NULL,
  commit_paths = ".",
  force = FALSE,
  private_key_name = "TIC_DEPLOY_KEY"
)
```

## Arguments

- ...:

  Passed on to
  [`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md)

- deploy:

  `[flag]`  
  If `TRUE`, deployment setup is performed before building the pkgdown
  site, and the site is deployed after building it. Set to `FALSE` to
  skip deployment. By default (if `deploy` is `NULL`), deployment
  happens if the following conditions are met:

  1.  The repo can be pushed to (see
      [`ci_can_push()`](https://docs.ropensci.org/tic/dev/reference/ci.md)).
      account for old default "id_rsa"

  2.  The `branch` argument is `NULL` (i.e., if the deployment happens
      to the active branch), or the current branch is the default
      branch, or contains "cran-" in its name (for compatibility with
      fledge) (see
      [`ci_get_branch()`](https://docs.ropensci.org/tic/dev/reference/ci.md)).

- orphan:

  `[flag]`  
  Create and force-push an orphan branch consisting of only one commit?
  This can be useful e.g. for `path = "docs", branch = "gh-pages"`, but
  cannot be applied for pushing to the current branch.

- checkout:

  `[flag]`  
  Check out the current contents of the repository? Defaults to `TRUE`,
  set to `FALSE` if the build process relies on existing contents or if
  you deploy to a different branch.

- path, branch:

  By default, this macro deploys the `docs` directory to the `gh-pages`
  branch. This is different from
  [`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md).

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

- private_key_name:

  `string`  
  Only needed when deploying from builds on GitHub Actions. If you have
  set a custom name for the private key during creation of the SSH key
  pair via tic::use_ghactions_deploy()\] or
  [`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md),
  pass this name here.

## See also

Other macros:
[`do_blogdown()`](https://docs.ropensci.org/tic/dev/reference/do_blogdown.md),
[`do_bookdown()`](https://docs.ropensci.org/tic/dev/reference/do_bookdown.md),
[`do_drat()`](https://docs.ropensci.org/tic/dev/reference/do_drat.md),
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md),
[`do_readme_rmd()`](https://docs.ropensci.org/tic/dev/reference/do_readme_rmd.md),
[`list_macros()`](https://docs.ropensci.org/tic/dev/reference/list_macros.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dsl_init()

do_pkgdown()

dsl_get()
} # }
```
