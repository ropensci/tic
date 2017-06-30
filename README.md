# tic [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)

The goal of tic is to faciliate deployment tasks for R packages tested by [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.
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

Stages can have arbitrary names, but the default `.travis.yml` and `appveyor.yml` files use the following stage names:

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

- `step_hello_world`: Hello, World!
- `step_run_code`: run arbitrary code, install dependent packages
    - `add_step(step_run_code(...))` can be abbreviated with `add_code_step(...)`
- `step_install_ssh_key`: make available a private SSH key (which has been added before to your project by [`travis`](https://github.com/ropenscilabs/travis)`::use_travis_deploy()`)
- `step_test_ssh`: test the SSH connection to GitHub
- `step_build_pkgdown`: building package documentation via [pkgdown](https://github.com/hadley/pkgdown)
- `step_push_deploy`: deploy to GitHub, with arguments:
    - `path`: which path to deploy, default: `"."`
    - `branch`: which branch to deploy to, default: `ci()$get_branch()`
    - `orphan`: should the branch consist of a single commit that contains all changes (`TRUE`), or should it be updated incrementally (`FALSE`, default)
        - You must specify a `branch` if you set `orphan = TRUE`
    - `remote_url`: the remote URL to push to, default: the URL related to the Travis run
    - `commit_message`: the commit message, will by default contain `[ci skip]` to avoid a loop, and useful information related to the CI run

Writing a [custom step](#custom-steps) is very easy, pull requests to this package are most welcome.


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


## Custom steps

A step is an environment-like (or list-like) object with named members `check`, `prepare`, and `run`.
These members should be functions that are callable without arguments.
The tic package uses [R6](https://github.com/wch/R6) to define a base class `TicStep`.
All steps defined by tic, including the example `HelloWorld` step, use `TicStep` as a base class.
See [`steps-base.R`](https://github.com/ropenscilabs/tic/blob/master/R/steps-base.R) for the implementation.
The `step_...` functions in tic are simply the `new()` methods of the corresponding R6 class objects.
I recommend following the same pattern for your custom steps.

In the following, the three methods which your derived class must override are described.

### `check()`

This function should return a logical scalar.
The task will be prepared and run only if this function returns `TRUE`.


### `prepare()`

This method will be called by `before_script()`.
It is intended to run in the `before_script` phase of the CI run.
You should install all dependent packages here, which then can be cached by the CI system.
You also may include further preparation code here.


### `run()`

This method will be called by `after_success()` or `deploy()`,
depending on your configuration.
It is intended to run in the `after_success` or `deploy` phases of the CI run.
The main difference is that only failed `deploy` tasks will fail the build.
