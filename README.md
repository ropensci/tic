# tic

The goal of tic is to faciliate deployment tasks for R packages tested by [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.
The intended usage is as follows:
- You specify the tasks to be run (and their parameters) in a central location
    - currently an environment variable, which makes the process compatible with a build matrix
    - will soon be replaced by a more fancy method such as a `.yml` file
- You add boilerplate code for installation of tic, and three function calls into tic, to `.travis.yml`/`appveyor.yml`/... (shown below)
- tic takes care of checking if a task is supposed to run, installation of dependencies (only if necessary), and running the tasks at the right time

## Installation

You can install tic from github with:


``` r
# install.packages("devtools")
devtools::install_github("krlmlr/tic")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```
