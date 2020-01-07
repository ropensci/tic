# tic

<!-- badges: start -->
[![Travis build status](https://img.shields.io/travis/ropenscilabs/tic/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.com/ropenscilabs/tic)
[![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic)
[![CircleCI](https://img.shields.io/circleci/build/gh/ropenscilabs/tic/master?label=Linux&logo=circle&logoColor=green&style=flat-square)](https://circleci.com/gh/ropenscilabs/tic)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![codecov](https://codecov.io/gh/ropenscilabs/tic/branch/master/graph/badge.svg)](https://codecov.io/gh/ropenscilabs/tic)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://badges.ropensci.org/305_status.svg)](https://github.com/ropensci/software-review/issues/305)
<!-- badges: end -->

The goal of tic is to enhance and simplify working with continuous integration (CI) systems.

The following ones are supported: 

- [Travis CI](https://travis-ci.org) (Linux, macOS)
- [AppVeyor](https://www.appveyor.com/) (Windows)
- [Circle CI](https://circleci.com/) (Linux)

To learn more about CI, read [the "Travis CI for test automation" blog post](http://mahugh.com/2016/09/02/travis-ci-for-test-automation/) and our [Getting Started](https://ropenscilabs.github.io/tic/articles/tic.html#prerequisites) vignette.

The most important improvements over existing solutions are:

1. Deployment to a Git repository is greatly simplified. Update your repository with results from the CI build.

1. Support for R packages and other kinds of project (bookdown, blogdown, etc.), with predefined templates. 
   Set up your project to deploy rendered versions of your book or blog with a single push to Git.

1. Workflow specification in a single `.R` file, regardless of CI system used.  
   Forget about `.yml` files or web browser configurations.

## Installation

It can be installed from GitHub with:

```r
# install.packages("remotes")
remotes::install_github("ropenscilabs/tic")
```

## Setup

By calling `tic::use_tic()` a production ready CI setup is initialized, tailored to your specific R project.
The created templates will use the providers https://travis-ci.org, https://appveyor.com and https://circleci.com.

If only the CI YAML templates from _tic_ are desired, the `use_<provider>_yml()` functions can be used.
Refer to [the complete list of options](https://docs.ropensci.org/tic/reference/yaml-templates.html).

For an R package, the following steps will be set up for the CI workflow:

- Installation of required dependencies for the project
- Satisfying build-time dependencies of steps to be run in all CI stages
- Running `rcmdcheck::rcmdcheck()`
- Building of a `pkgdown` site with deployment GitHub
- Running a code coverage and uploading it to [codecov.io](https://codecov.io/)

See the [Getting Started](https://ropenscilabs.github.io/tic/articles/tic.html) vignette for more information and links to [minimal example repositories](https://ropenscilabs.github.io/tic/articles/tic.html#examples-projects) for various R projects (package, blogdown, bookdown and more).

## Examples

All examples listed here work with Travis, some work with AppVeyor too. The badges link to the most recent build of the master branch.

- [tic.blogdown](https://github.com/ropenscilabs/tic.blogdown): Blogs with [_blogdown_](https://bookdown.org/yihui/blogdown/)

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.blogdown/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.blogdown)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-blogdown?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-blogdown)

- [tic.bookdown](https://github.com/ropenscilabs/tic.bookdown): Books with [_bookdown_](https://bookdown.org/)

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.bookdown/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.bookdown)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-bookdown?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-bookdown)
    
- [tic.covrpage](https://github.com/ropenscilabs/tic.covrpage): Unit test summary report.

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.covrpage/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.covrpage)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-covrpage?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-covrpage)
    
- [tic.drat](https://github.com/ropenscilabs/tic.drat): CRAN-like package repositories with [_drat_](http://dirk.eddelbuettel.com/code/drat.html)

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.drat/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.drat)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-drat?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-drat)
    <a href="https://codecov.io/github/ropenscilabs/tic.drat?branch=master"><img src="https://codecov.io/gh/ropenscilabs/tic.drat/branch/master/graph/badge.svg" alt="Coverage Status"/></a></p>

- [tic.figshare](https://github.com/ropenscilabs/tic.figshare): Deploying artifacts to [figshare](https://figshare.com/) (work in progress).

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.figshare/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.figshare)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-figshare?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-figshare)

- [tic.package](https://github.com/ropenscilabs/tic.package): R packages with [_pkgdown_](https://pkgdown.r-lib.org/) documentation

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.package/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.package)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-package?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-package)
    <a href="https://codecov.io/github/ropenscilabs/tic.package?branch=master"><img src="https://codecov.io/gh/ropenscilabs/tic.package/branch/master/graph/badge.svg" alt="Coverage Status"/></a></p>

- [tic.packagedocs](https://github.com/ropenscilabs/tic.packagedocs): R packages with [_packagedocs_](http://hafen.github.io/packagedocs/) documentation

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.packagedocs/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.packagedocs)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-packagedocs?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-packagedocs)
    <a href="https://codecov.io/github/ropenscilabs/tic.packagedocs?branch=master"><img src="https://codecov.io/gh/ropenscilabs/tic.packagedocs/branch/master/graph/badge.svg" alt="Coverage Status"/></a></p>
    
- [tic.website](https://github.com/ropenscilabs/tic.website): Websites with [_rmarkdown_](https://rmarkdown.rstudio.com/)

    [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.website/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.website)
    [![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic-website?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic-website)

## Vignettes

- [Get started](https://ropenscilabs.github.io/tic/articles/tic.html)

- [Feature Overview](https://ropenscilabs.github.io/tic/articles/features.html)

- [The CI Build Lifecycle](https://ropenscilabs.github.io/tic/articles/build-lifecycle.html)

- [CI Client Packages](https://ropenscilabs.github.io/tic/articles/ci-client-packages.html)

- [Advanced Usage](https://ropenscilabs.github.io/tic/articles/advanced.html)

- [Deployment](https://ropenscilabs.github.io/tic/articles/deployment.html)

- [Custom Steps](https://ropenscilabs.github.io/tic/articles/custom-steps.html)

## Limitations

The setup functions in this package assume Git as version control system, and GitHub as platform.  Automated setup works best if the project under test is located in the root of the Git repository.  Multi-project repositories are not supported, see [the comment by @jwijffels](https://github.com/ropenscilabs/tic/issues/117#issuecomment-460814990) for guidance to work around this limitation.

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
