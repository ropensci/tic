# tic [![Travis-CI Build Status](https://travis-ci.org/krlmlr/tic.svg?branch=master)](https://travis-ci.org/krlmlr/tic)

The goal of tic is to faciliate deployment tasks for R packages tested by [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.
The intended usage is as follows:
- You specify the tasks to be run (and their parameters) in a central location
    - currently an environment variable, which makes the process compatible with a build matrix
    - will soon be replaced by a more fancy method such as a `.yml` file
- You add boilerplate code for installation of tic, and three function calls into tic, to [`.travis.yml`](#travis)/`appveyor.yml`/... (shown below)
- tic takes care of checking if a task is supposed to run, installation of dependencies (only if necessary), and running the tasks at the right time

## Installation

You can install tic from github with:

``` r
# install.packages("devtools")
devtools::install_github("ropenscilabs/tic")
```


## Tasks

Currently, the tic package supports the following tasks:

- `task_hello_world`: Hello, World!
- `task_run_covr`: run a coverage analysis via [covr](https://github.com/jimhester/covr) (with upload to [Codecov](https://codecov.io/gh))
- `task_install_ssh_key`: make available a private SSH key (which has been added before to your project by [`travis`](https://github.com/ropenscilabs/travis)`::use_travis_deploy()`)
- `task_test_ssh`: test the SSH connection to GitHub
- `task_build_pkgdown`: building package documentation via [pkgdown](https://github.com/hadley/pkgdown), with arguments:
    - `on_branch`: on which branch(es) the task is run, default: `"master"`
        - specify a character vector to check against multiple branches, a regex with `"/.../"`, or `NULL` to run on all branches
- `task_push_deploy`: deploy to GitHub, with arguments:
    - `on_branch`: on which branch(es) the task is run, default: `"master"`
        - specify a character vector to check against multiple branches, a regex with `"/.../"`, or `NULL` to run on all branches
    - `path`: which path to deploy, default: `"."`
    - `branch`: which branch to deploy to, default: `ci()$get_branch()`
    - `orphan`: should the branch consist of a single commit that contains all changes (`TRUE`), or should it be updated incrementally (`FALSE`, default)
        - You must specify a `branch` if you set `orphan = TRUE`
    - `remote_url`: the remote URL to push to, default: the URL related to the Travis run
    - `commit_message`: the commit message, will by default contain `[ci skip]` to avoid a loop, and useful information related to the CI run

Writing a [custom task](#custom-tasks) is very easy, pull requests to this package are most welcome.


## Extending CI configurations

### Travis

The following example runs a coverage check after a successful run, and builds pkgdown and deploys to the `gh-pages` branch only on the `production` branch.

```yml
language: r

#env
env:
  global:
  - TIC_AFTER_SUCCESS_TASKS="task_run_covr"

#matrix: 3x Linux
matrix:
  include:
  - r: release
    env:
    - TIC_DEPLOY_TASKS="task_build_pkgdown; task_install_ssh_keys; task_test_ssh; task_push_deploy(path = 'docs', branch = 'gh-pages', on_branch = 'production')"
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

By default, the `before_script()`, `after_success()` and `deploy()` methods query the environment variables ``TIC_AFTER_SUCCESS_TASKS` and `TIC_DEPLOY_TASKS` (via the functions `get_after_success_task_code()` and `get_deploy_task_code()`).
You are free to call these functions with a character vector instead.
