# tic

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

The goal of tic is to facilitate testing and deployment tasks for R projects in [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.

In a nutshell, `tic` does the following:  

- Installation of required dependencies for the project  
- Satisfying dependencies of steps to be run in all CI stages
- Running `rcmdcheck::rcmdcheck()` (if the project is an R package)  
- Building of a `pkgdown` site and deployment to the `docs/` folder of the `master` branch (Travis only, R package only)  
- Running a code coverage and uploading it to [codecov.io](https://codecov.io/) (Travis only, R package only)  

It comes with pre-defined templates for various R projects (package, bookdown, blogdown, etc.) and provides CI-agnostic workflow definitions (for the CI stages).

## Installation

It can be installed from Github with:

``` r
# install.packages("remotes")
remotes::install_github("ropenscilabs/tic")
```

## Setup

When using `tic` it is helpful to be somewhat familiar with the concept of [continuous integration](https://ropenscilabs/tic/articles/tic.html#prerequisites) (CI).  
By calling `usethis::use_ci()` a production ready setup for the respective R project is initialized.  
This function will create a CI setup for both providers Travis and Appveyor.  
For more information see the [Getting started](https://ropenscilabs.github.io/tic/articles/tic.html#setup) vignette.

## Further reading

- [Example projects](https://ropenscilabs.github.io/tic/articles/tic.html#examples)  
- [Advanced usage](https://ropenscilabs.github.io/tic/articles/advanced.html)
- [Developer information](https://ropenscilabs.github.io/tic/articles/custom-steps.html)

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
