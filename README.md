# tic

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

The goal of tic is to enhance and simplify working with continuous integration (CI) systems like [Travis CI](https://travis-ci.org) or [AppVeyor](https://www.appveyor.com/) for R projects.  To learn more about CI, read [this blog post](http://mahugh.com/2016/09/02/travis-ci-for-test-automation/) and our [Getting Started](https://ropenscilabs/tic/articles/tic.html#prerequisites) vignette.

The most important improvements over existing solutions are:

1. Deployment to a Git repository is greatly simplified. Update your repository with results from the CI build.

1. Support for R packages and other kinds of project (bookdown, blogdown, etc.), with predefined templates. 
   Set up your project to deploy rendered versions of your book or blog with a single push to Git.

1. Workflow specification in a single `.R` file, regardless of CI system used.  
   Forget about `.yml` files or web browser configurations.

## Installation

It can be installed from Github with:

``` r
# install.packages("remotes")
remotes::install_github("ropenscilabs/tic")
```

## Setup

By calling `usethis::use_ci()` a production ready CI setup is initialized, tailored to your specific R project.
The created templates will use the providers https://travis-ci.org and https://appveyor.com.
For an R package, the following steps will be set up for the CI workflow:

- Installation of required dependencies for the project
- Satisfying build-time dependencies of steps to be run in all CI stages
- Running `rcmdcheck::rcmdcheck()`
- Building of a `pkgdown` site, with deployment to the `docs/` directory of the `master` branch
- Running a code coverage and uploading it to [codecov.io](https://codecov.io/)

See the [Getting Started](https://ropenscilabs/tic/articles/tic.html) vignette for more information and links to [minimal example repositories](https://ropenscilabs/tic/articles/tic.html#examples-projects) for various R projects (package, blogdown, bookdown and more).

## Vignettes

- [Advanced usage](https://ropenscilabs.github.io/tic/articles/advanced.html)
- [Build lifecycle](https://ropenscilabs.github.io/tic/articles/build-lifecycle.html)
- [tic advantages](https://ropenscilabs.github.io/tic/articles/advantages.html)
- [tic, travis and usethis](https://ropenscilabs.github.io/tic/articles/tic-usethis-travis.html)
- [Developer information](https://ropenscilabs.github.io/tic/articles/custom-steps.html)

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
