# tic [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.svg?branch=master)](https://travis-ci.org/krlmlr/tic)

The goal of tic is to faciliate deployment tasks for R packages tested by [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.
The intended usage is as follows:
- You specify the steps to be run (and their parameters) in a central location in a simple domain-specific language
- You add boilerplate code for installation of tic, and three function calls into tic, to [`.travis.yml`](#travis)/`appveyor.yml`/... (shown below)
- tic takes care of checking if a step is supposed to run, installation of dependencies (only if necessary), and running the enabled steps at the right time

## Installation

You can install tic from github with:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/tic")
```


## Steps

A step consists of:

1. a [task](#tasks) definition
2. a branch filter (optional)
3. an environment variable name (optional)

For each step, the corresponding task is run, if and only if the branch filter matches the current branch (if defined) and the environment variable has a non-zero value (if defined).
A step without branch filter and environment variable name is always run.

The environment variable name allow simple interaction with the build matrix of the CI system.
You can enable or disable steps by simply setting an environment variable.

By default, the steps for a CI run are loaded from the [`tic.R`](https://github.com/krlmlr/tic/blob/master/tic.R) file in the package root.


## Tasks

Currently, the tic package supports the following tasks:

- `task_hello_world`: Hello, World!
- `task_run_covr`: run a coverage analysis via [covr](https://github.com/jimhester/covr) (with upload to [Codecov](https://codecov.io/gh))
- `task_install_ssh_key`: make available a private SSH key (which has been added before to your project by [`travis`](https://github.com/ropenscilabs/travis)`::use_travis_deploy()`)
- `task_test_ssh`: test the SSH connection to GitHub
- `task_build_pkgdown`: building package documentation via [pkgdown](https://github.com/hadley/pkgdown)
- `task_push_deploy`: deploy to GitHub, with arguments:
    - `path`: which path to deploy, default: `"."`
    - `branch`: which branch to deploy to, default: `ci()$get_branch()`
    - `orphan`: should the branch consist of a single commit that contains all changes (`TRUE`), or should it be updated incrementally (`FALSE`, default)
        - You must specify a `branch` if you set `orphan = TRUE`
    - `remote_url`: the remote URL to push to, default: the URL related to the Travis run
    - `commit_message`: the commit message, will by default contain `[ci skip]` to avoid a loop, and useful information related to the CI run

Writing a [custom task](#custom-tasks) is very easy, pull requests to this package are most welcome.


## CI configurations

### Travis

The following example runs a coverage check after a successful run, and builds pkgdown and deploys to the `gh-pages` branch only on the `production` branch.


#### `.travis.yml`

```yml
language: r

#matrix: 3x Linux
matrix:
  include:
  - r: release
    env:
    - BUILD_PKGDOWN=true
  - r: oldrel
  - r: devel

#before_script
before_script:
- R -q -e 'devtools::install_github("ropenscilabs/tic"); tic::before_script()'

#after_success (deploy to gh-pages)
after_success:
- R -q -e 'tic::after_success()'

#deploy
deploy:
  provider: script
  script: R -q -e 'tic::deploy()'
  on:
    all_branches: true
```

#### `tic.R`

```r
after_success <- list(
  step(task_run_covr)
)

deploy <- list(
  step(task_build_pkgdown, on_branch = "production", on_env = "BUILD_PKGDOWN"),
  step(task_install_ssh_keys),
  step(task_test_ssh),
  step(task_push_deploy, path = "docs", branch = "gh-pages", on_branch = "production", on_env = "BUILD_PKGDOWN")
)
```


## Custom tasks

A task is an environment-like (or list-like) object with named members `check`, `prepare`, and `run`.
These members should be functions that are callable without arguments.
The tic package uses [R6](https://github.com/wch/R6) to define a base class `TravisTask`.
All tasks defined by tic, including the example `HelloWorld` task, are derived from `TravisTask`.
See [`tasks-base.R`](https://github.com/krlmlr/tic/blob/master/R/tasks-base.R) for the implementation.

The user specifies the tasks to be run as a semicolon-separated list of functions or expressions that create a task object.
The `task_...` functions in tic are simply the `new()` methods of the corresponding R6 class objects.
I recommend following the same pattern for your custom tasks.

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


## How tasks are run

By default, the `before_script()`, `after_success()` and `deploy()` methods call `get_after_success_steps()` and/or `get_deploy_steps()`, which source the `tic.R` file and extract the variables `after_success` or `deploy` from the result.
You can also call these functions with a list of step objects (created with `step()`) instead.
