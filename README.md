# tic

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

The goal of tic is to facilitate testing and deployment tasks for R projects in [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.

In a nutshell, `tic` does the following:  

- Installation of required dependencies for the project  
- Satisfying dependencies of steps to be run in all CI stages
- Running `rcmdcheck::rcmdcheck()` (if the project is an R package)  
- Building of a `pkgdown` site and deployment to the `docs/` folder of the `master` branch
- Running a code coverage and uploading it to [codecov.io](https://codecov.io/)

It comes with pre-defined templates for various R projects (package, bookdown, blogdown, etc.) and provides CI-agnostic workflow definitions (for the CI stages).

## Installation

It can be installed from Github with:

``` r
# install.packages("remotes")
remotes::install_github("ropenscilabs/tic")
```

## Setup

When using `tic` some basic knowledge about continuous integration (CI) is required.
You may find [this resource](http://mahugh.com/2016/09/02/travis-ci-for-test-automation/) and our [Getting Started](https://ropenscilabs/tic/articles/tic.html#prerequisites) vignette helpful. 
The latter also contains links to minimal example repositories for various R projects (package, blogdown, bookdown and more).

By calling `usethis::use_ci()` a production ready CI setup is initialized, tailored to your specific R project.  
The created templates will use the providers https://travis-ci.org and https://appveyor.com.

## Vignettes

- [Advanced usage](https://ropenscilabs/tic/articles/advanced.html)
- [Build lifecycle](https://ropenscilabs/tic/articles/build-lifecycle.html)
- [tic advantages](https://ropenscilabs/tic/articles/tic-advantages.html)
- [tic, travis and usethis](https://ropenscilabs/tic/articles/tic-usethis-travis.html)
- [Developer information](https://ropenscilabs/tic/articles/custom-steps.html)

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
