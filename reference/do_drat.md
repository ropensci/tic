# Build and deploy drat repository

`do_drat()` builds and deploys R packages to a drat repository and adds
default steps to the `"install"`, `"before_deploy"` and `"deploy"`
stages:

1.  [`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md)
    in the `"before_deploy"` to setup the upcoming deployment

2.  [`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
    in the `"before_deploy"` stage (if `deploy` is set),

3.  [`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md)
    in the `"deploy"`

4.  [`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md)
    in the `"deploy"` stage.

## Usage

``` r
do_drat(
  repo_slug = NULL,
  orphan = FALSE,
  checkout = TRUE,
  path = "~/git/drat",
  branch = NULL,
  remote_url = NULL,
  commit_message = NULL,
  commit_paths = ".",
  force = FALSE,
  private_key_name = "TIC_DEPLOY_KEY",
  deploy_dev = FALSE
)
```

## Arguments

- repo_slug:

  `[string]`  
  The name of the drat repository to deploy to in the form
  `:owner/:repo`.

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

  By default, this macro deploys the default repo branch (usually
  "master") of the drat repository. An alternative option is
  `"gh-pages"`.

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

- deploy_dev:

  `[logical]`  
  Should development versions of packages also be deployed to the drat
  repo? By default only "major", "minor" and "patch" releases are build
  and deployed.

## Deployment

Deployment can only happen to the default repo branch (usually "master")
or `gh-pages` branch because the GitHub Pages functionality from GitHub
is used to access the drat repository later on. You need to enable this
functionality when creating the drat repository on GitHub via
`Settings -> GitHub pages` and set it to the chosen setting here.

To build and deploy Windows and macOS binaries, builds with deployment
permissions need to be triggered. Have a look at
<https://docs.ropensci.org/tic/articles/deployment.html> for more
information and instructions.

## See also

Other macros:
[`do_blogdown()`](https://docs.ropensci.org/tic/dev/reference/do_blogdown.md),
[`do_bookdown()`](https://docs.ropensci.org/tic/dev/reference/do_bookdown.md),
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md),
[`do_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/do_pkgdown.md),
[`do_readme_rmd()`](https://docs.ropensci.org/tic/dev/reference/do_readme_rmd.md),
[`list_macros()`](https://docs.ropensci.org/tic/dev/reference/list_macros.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dsl_init()

do_drat()

dsl_get()
} # }
```
