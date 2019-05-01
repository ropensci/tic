# tic

[![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic)
[![Build status](https://ci.appveyor.com/api/projects/status/r8w1psd0f5r4hs6t/branch/master?svg=true)](https://ci.appveyor.com/project/ropensci/tic/branch/master)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

The goal of tic is to enhance and simplify working with continuous integration (CI) systems like [Travis CI](https://travis-ci.org) or [AppVeyor](https://www.appveyor.com/) for R projects.  To learn more about CI, read [this blog post](http://mahugh.com/2016/09/02/travis-ci-for-test-automation/) and our [Getting Started](https://ropenscilabs.github.io/tic/articles/tic.html#prerequisites) vignette.

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

By calling `tic::use_tic()` a production ready CI setup is initialized, tailored to your specific R project.
The created templates will use the providers https://travis-ci.org and https://appveyor.com.
For an R package, the following steps will be set up for the CI workflow:

- Installation of required dependencies for the project
- Satisfying build-time dependencies of steps to be run in all CI stages
- Running `rcmdcheck::rcmdcheck()`
- Building of a `pkgdown` site, with deployment to the `docs/` directory of the `master` branch
- Running a code coverage and uploading it to [codecov.io](https://codecov.io/)

See the [Getting Started](https://ropenscilabs.github.io/tic/articles/tic.html) vignette for more information and links to [minimal example repositories](https://ropenscilabs.github.io/tic/articles/tic.html#examples-projects) for various R projects (package, blogdown, bookdown and more).

## Examples

- [tic.blogdown](https://github.com/ropenscilabs/tic.blogdown): Blogs with [_blogdown_](https://bookdown.org/yihui/blogdown/)

    [![Travis build status](https://travis-ci.org/ropenscilabs/tic.blogdown.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.blogdown)
    [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.blogdown?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/tic.blogdown)
    [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.blogdown/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.blogdown?branch=master)
    
- [tic.bookdown](https://github.com/ropenscilabs/tic.bookdown): Books with [_bookdown_](https://bookdown.org/)

    [![Travis build status](https://travis-ci.org/ropenscilabs/tic.bookdown.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.bookdown)
    [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.bookdown?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/tic.bookdown)
    [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.bookdown/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.bookdown?branch=master)
    
- [tic.covrpage](https://github.com/ropenscilabs/tic.covrpage): Unit test summary report.

    [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.covrpage.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.covrpage)
    [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.covrpage?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/tic.covrpage)
    [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.covrpage/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.covrpage?branch=master)
    
- [tic.drat](https://github.com/ropenscilabs/tic.drat): CRAN-like package repositories with [_drat_](http://dirk.eddelbuettel.com/code/drat.html)

    [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.drat.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.drat) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.drat?branch=master&svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic.drat) [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.drat/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.drat?branch=master)
    
- [tic.figshare](https://github.com/ropenscilabs/tic.figshare): Deploying artifacts to [figshare](https://figshare.com/) (work in progress).

    [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.fighare.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.fighare)
    [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.fighare?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/tic.fighare)
    [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.fighare/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.fighare?branch=master)

- [tic.package](https://github.com/ropenscilabs/tic.package): R packages with [_pkgdown_](https://pkgdown.r-lib.org/) documentation

    [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.package.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.package) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.package?branch=master&svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-package) [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.package/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.package?branch=master)
    
- [tic.packagedocs](https://github.com/ropenscilabs/tic.packagedocs): R packages with [_packagedocs_](http://hafen.github.io/packagedocs/) documentation

    [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.packagedocs.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.packagedocs) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.packagedocs?branch=master&svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-packagedocs) [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.packagedocs/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.packagedocs?branch=master)
    
- [tic.website](https://github.com/ropenscilabs/tic.website): Websites with [_rmarkdown_](https://rmarkdown.rstudio.com/)

    [![Travis-CI Build Status](https://travis-ci.org/ropenscilabs/tic.website.svg?branch=master)](https://travis-ci.org/ropenscilabs/tic.website)
    [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropenscilabs/tic.website?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/tic.website)
    [![Coverage Status](https://codecov.io/gh/ropenscilabs/tic.website/branch/master/graph/badge.svg)](https://codecov.io/github/ropenscilabs/tic.website?branch=master)
    
## Vignettes

- [Advanced usage](https://ropenscilabs.github.io/tic/articles/advanced.html)
- [Build lifecycle](https://ropenscilabs.github.io/tic/articles/build-lifecycle.html)
- [tic advantages](https://ropenscilabs.github.io/tic/articles/advantages.html)
- [tic, travis and usethis](https://ropenscilabs.github.io/tic/articles/tic-usethis-travis.html)
- [Developer information](https://ropenscilabs.github.io/tic/articles/custom-steps.html)

## Limitations

The setup functions in this package assume Git as version control system, and GitHub as platform.  Automated setup works best if the project under test is located in the root of the Git repository.  Multi-project repositories are not supported, see [the comment by @jwijffels](https://github.com/ropenscilabs/tic/issues/117#issuecomment-460814990) for guidance to work around this limitation.

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
