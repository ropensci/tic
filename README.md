# tic

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)

The goal of tic is to facilitate testing and deployment tasks for R packages in [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.
The intended usage is as follows:
- You specify the steps to be run at each stage in a central location in a simple domain-specific language
- You add boilerplate code for installation of tic, and three function calls into tic, to [`.travis.yml`](#travis)/`appveyor.yml`/... (shown below)
- tic takes care of checking if a step is supposed to run, preparing the step if necessary (e.g., installation of dependencies), and running the enabled steps at the right time

## Installation

You can install tic from github with:

``` r
# install.packages("remotes")
remotes::install_github("ropenscilabs/tic")
```

## Setup

1. Set up GitHub, Travis CI, and GitHub PAT and deploy key:

    ``` r
    # install.packages("remotes")
    remotes::install_github("ropenscilabs/travis")
    travis::use_tic()
    ```

2. Edit `tic.R` as appropriate.


## Example applications

- [R package with pkgdown documentation](https://github.com/krlmlr/tic.package)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.package.svg?branch=master)](https://travis-ci.org/krlmlr/tic.package) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/krlmlr/tic.package?branch=master&svg=true)](https://ci.appveyor.com/project/krlmlr/tic-package) [![Coverage Status](https://codecov.io/gh/krlmlr/tic.package/branch/master/graph/badge.svg)](https://codecov.io/github/krlmlr/tic.package?branch=master)

- [R package with packagedocs documentation](https://github.com/krlmlr/tic.packagedocs)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.packagedocs.svg?branch=master)](https://travis-ci.org/krlmlr/tic.packagedocs) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/krlmlr/tic.packagedocs?branch=master&svg=true)](https://ci.appveyor.com/project/krlmlr/tic.packagedocs) [![Coverage Status](https://codecov.io/gh/krlmlr/tic.packagedocs/branch/master/graph/badge.svg)](https://codecov.io/github/krlmlr/tic.packagedocs?branch=master)

- [R package with auto-deploy to drat](https://github.com/krlmlr/tic.drat)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.drat.svg?branch=master)](https://travis-ci.org/krlmlr/tic.drat) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/krlmlr/tic.drat?branch=master&svg=true)](https://ci.appveyor.com/project/krlmlr/tic.drat) [![Coverage Status](https://codecov.io/gh/krlmlr/tic.drat/branch/master/graph/badge.svg)](https://codecov.io/github/krlmlr/tic.drat?branch=master)

- [An rmarkdown website](https://github.com/krlmlr/tic.website)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.website.svg?branch=master)](https://travis-ci.org/krlmlr/tic.website)

- [A bookdown book](https://github.com/krlmlr/tic.bookdown)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.bookdown.svg?branch=master)](https://travis-ci.org/krlmlr/tic.bookdown)

- [A blogdown blog](https://github.com/krlmlr/tic.blogdown)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.blogdown.svg?branch=master)](https://travis-ci.org/krlmlr/tic.blogdown)

- [Publishing to figshare](https://github.com/krlmlr/tic.figshare)

    [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.figshare.svg?branch=master)](https://travis-ci.org/krlmlr/tic.figshare)




## Stages and steps

Many CI systems organize a run in stages, tic embraces this concept.
Each stage has a name (e.g., `"after_success"`, `"deploy"`, ...)
and has an arbitrary number of steps.
Each step represents a self-contained action,
which may require preparation (such as installing dependencies)
and/or have arbitrary criteria if it is run.
By default, the steps for a CI run are defined in the `tic.R` file
in the package root.

The `tic.R` file is modeled after the following pattern:

```r
get_stage("<stage_name>") %>%
  add_step(step_...(...)) %>%
  ...
```

Add the steps you want to run at each stage.
You can also use more complex R code to add steps conditionally or to parametrize them.

The `use_tic()` function in the [travis package](https://github.com/ropenscilabs/travis) creates default `.travis.yml`, `appveyor.yml` and `tic.R` files for many kinds of project.
You are free to adapt/enhance the `tic.R` file, but you should only rarely need to edit `.travis.yml` or `appveyor.yml` (perhaps to define a build matrix or to preset an environment variable).


### Stages

The following build stages are available:

- `before_install`
- `install`
- `after_install`
- `before_script`
- `script`
- `after_success`
- `after_failure`
- `before_deploy`
- `deploy`
- `after_deploy`
- `after_script`

For each of the predefined stage names, a corresponding function that runs the steps of this stage is provided.
The `tic()` function runs most of these stages, this is useful for local debugging.


### Steps

Among others, the tic package defines the following steps:

- `step_hello_world`: print "Hello, World!" to the console, helps testing a tic setup
- `step_rcmdcheck`: run `R CMD check` via the _rcmdcheck_ package
- `step_run_code`: run arbitrary code, optionally run preparatory code and install dependent packages
    - `add_step(step_run_code(...))` can be abbreviated with `add_code_step(...)`
- `step_install_ssh_key`: make available a private SSH key (which has been added before to your project by [`usethis`](https://github.com/r-lib/usethis)`::use_travis_deploy()`)
- `step_test_ssh`: test the SSH connection to GitHub, helps troubleshooting deploy problems
- `step_build_pkgdown`: building package documentation via [pkgdown](https://github.com/r-lib/pkgdown)
- `step_push_deploy`: deploy to GitHub, with arguments:
    - `path`: which path to deploy, default: `"."`
    - `branch`: which branch to deploy to, default: `ci()$get_branch()`
    - `orphan`: should the branch consist of a single commit that contains all changes (`TRUE`), or should it be updated incrementally (`FALSE`, default)
        - You must specify a `branch` if you set `orphan = TRUE`
    - `remote_url`: the remote URL to push to, default: the URL related to the Travis run
    - `commit_message`: the commit message, will by default contain `[ci skip]` to avoid a loop, and useful information related to the CI run
    - `commit_paths`: Which path(s) to commit. Useful to only commit single files that have changed during the CI run.


## How steps are run

The `load_from_file()` sources the `tic.R` file and returns the stages defined there
(as a list of [`Stage`](https://github.com/ropenscilabs/tic/blob/master/R/stage.R) objects).
You can call this function locally to troubleshoot your `tic.R` file.
By default, the `prepare_all_stages()` function
calls `load_from_file()` and prepares all running steps in all stages.
It is intended to be run in the `before_script` (or similar) stage of the CI run,
because the preparation may involve the installation of heavy dependencies
which then can be cached.
The `after_success()` and `deploy()` functions also
call `load_from_file()` and run the corresponding stage,
they are intended to run from their corresponding CI stages.
Other tic stages can be run easily with `run_stage()`.


---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
