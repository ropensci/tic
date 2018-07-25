# tic

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)

The goal of tic is to facilitate testing and deployment tasks for R packages in [Travis CI](https://travis-ci.org), [AppVeyor](https://www.appveyor.com/), or the CI tool of your choice.

In a nutshell, it does the following:
- Installs required dependencies of an R package
- Run `rcmdcheck::rcmdcheck()` on the package
- Build a `pkgdown` site and deploy it to the `docs/` folder of the `master` branch (Travis only)
- Run a code coverage on the package and upload it to [codecov.io](https://codecov.io/) (Travis only)

## Installation

You can install tic from github with:

``` r
# install.packages("remotes")
remotes::install_github("ropenscilabs/tic")
```

## Setup

[Getting started](https://ropenscilabs/tic/articles/tic.html#setup) with `tic`.

## Example applications

See [here](https://ropenscilabs/tic/articles/tic.html#examples).


## Advanced usage 

See [here](https://ropenscilabs/tic/articles/advanced.html).

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
