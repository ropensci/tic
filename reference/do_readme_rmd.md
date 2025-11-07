# Render a R Markdown README and deploy to Github

**\[experimental\]**

`do_readme_rmd()` renders an R Markdown README and deploys the rendered
README.md file to Github. It adds default steps to the `"before_deploy"`
and `"deploy"` stages:

1.  [`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md)
    in the `"before_deploy"` to setup the upcoming deployment

2.  [`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md)
    in the `"before_deploy"` stage

3.  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
    in the `"deploy"` stage

4.  [`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md)
    in the `"deploy"` stage.

## Usage

``` r
do_readme_rmd(
  checkout = TRUE,
  remote_url = NULL,
  commit_message = NULL,
  force = FALSE,
  private_key_name = "TIC_DEPLOY_KEY"
)
```

## Arguments

- checkout:

  `[flag]`  
  Check out the current contents of the repository? Defaults to `TRUE`,
  set to `FALSE` if the build process relies on existing contents or if
  you deploy to a different branch.

- remote_url:

  `[string]`  
  The URL of the remote Git repository to push to, defaults to the
  current GitHub repository.

- commit_message:

  `[string]`  
  Commit message to use, defaults to a useful message linking to the CI
  build and avoiding recursive CI runs.

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
[`do_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/do_pkgdown.md),
[`list_macros()`](https://docs.ropensci.org/tic/dev/reference/list_macros.md)

## Examples

``` r
if (FALSE) { # \dontrun{
dsl_init()

do_readme_rmd()

dsl_get()
} # }
```
