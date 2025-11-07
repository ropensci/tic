# Build a blogdown site

`do_blogdown()` adds default steps related to package checks to the
`"install"`, `"before_deploy"`, `"script"` and `"deploy"` stages.

1.  [`step_install_deps()`](https://docs.ropensci.org/tic/dev/reference/step_install_pkg.md)
    in the `"install"` stage

2.  [`blogdown::install_hugo()`](https://pkgs.rstudio.com/blogdown/reference/install_hugo.html)
    in the `"install"` stage to install the latest version of HUGO.

3.  [`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md)
    in the `"install"` stage.

4.  [`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md)
    in the `"before_deploy"` to setup the upcoming deployment (if
    `deploy` is set),

5.  [`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
    in the `"before_deploy"` stage (if `deploy` is set),

6.  [`step_build_blogdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_blogdown.md)
    in the `"deploy"` stage, forwarding all `...` arguments.

7.  [`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md)
    in the `"deploy"` stage.

By default, the `public/` directory is deployed to the `gh-pages`
branch, keeping the history. If the output directory of your blog/theme
is not `"public"` you need to change the `"path"` argument.

## Usage

``` r
do_blogdown(
  ...,
  deploy = NULL,
  orphan = FALSE,
  checkout = TRUE,
  path = "public",
  branch = "gh-pages",
  remote_url = NULL,
  commit_message = NULL,
  commit_paths = ".",
  force = FALSE,
  private_key_name = "TIC_DEPLOY_KEY",
  cname = NULL
)
```

## Arguments

- ...:

  Passed on to
  [`step_build_blogdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_blogdown.md)

- deploy:

  `[flag]`  
  If `TRUE`, deployment setup is performed before building the blogdown
  site, and the site is deployed after building it. Set to `FALSE` to
  skip deployment. By default (if `deploy` is `NULL`), deployment
  happens if the following conditions are met:

  1.  The repo can be pushed to (see
      [`ci_can_push()`](https://docs.ropensci.org/tic/dev/reference/ci.md)).

  2.  The `branch` argument is `NULL` (i.e., if the deployment happens
      to the active branch), or the current branch is the default repo
      branch (see
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

- private_key_name:

  `string`  
  Only needed when deploying from builds on GitHub Actions. If you have
  set a custom name for the private key during creation of the SSH key
  pair via tic::use_ghactions_deploy()\] or
  [`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md),
  pass this name here.

- cname:

  (`character(1)`  
  An optional URL for redirecting the created website A `CNAME` file
  containing the given URL will be added to the root of the directory
  specified in argument `path`.

## See also

Other macros:
[`do_bookdown()`](https://docs.ropensci.org/tic/dev/reference/do_bookdown.md),
[`do_drat()`](https://docs.ropensci.org/tic/dev/reference/do_drat.md),
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md),
[`do_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/do_pkgdown.md),
[`do_readme_rmd()`](https://docs.ropensci.org/tic/dev/reference/do_readme_rmd.md),
[`list_macros()`](https://docs.ropensci.org/tic/dev/reference/list_macros.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dsl_init()

do_blogdown()

dsl_get()
} # }
```
