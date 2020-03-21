# tic

<!-- badges: start -->

[![R CMD Check via
{tic}](https://img.shields.io/github/workflow/status/ropensci/tic/R%20CMD%20Check%20via%20%7Btic%7D?logo=github&label=R%20CMD%20Check%20via%20%7Btic%7D&style=flat-square)](https://github.com/ropensci/tic/actions)
[![Travis build status](https://img.shields.io/travis/ropensci/tic/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.com/ropensci/tic)
[![AppVeyor build status](https://img.shields.io/appveyor/ci/ropensci/tic?label=Windows&logo=appveyor&style=flat-square)](https://ci.appveyor.com/project/ropensci/tic)
[![CircleCI](https://img.shields.io/circleci/build/gh/ropensci/tic/master?label=Linux&logo=circle&logoColor=green&style=flat-square)](https://circleci.com/gh/ropensci/tic)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![codecov](https://codecov.io/gh/ropensci/tic/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/tic)
[![Lifecycle: maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![](https://badges.ropensci.org/305_status.svg)](https://github.com/ropensci/software-review/issues/305)

<!-- badges: end -->

The goal of tic is to enhance and simplify working with continuous integration (CI) systems.

The following ones are supported:

| Provider       | R package                                            | Platforms             | Info                                                                  |
| -------------- | ---------------------------------------------------- | --------------------- | --------------------------------------------------------------------- |
| Appveyor CI    | [{r-appveyor}](https://github.com/krlmlr/r-appveyor) | Windows               |                                                                       |
| Circle CI      | [{circle}](https://docs.ropensci.org/circle/)        | Linux                 | via Docker images from [rocker](https://github.com/rocker-org/rocker) |
| Github Actions | [{ghactions}](https://maxheld83.github.io/ghactions) | Linux, macOS, Windows |                                                                       |
| Travis CI      | [{travis}](https://docs.ropensci.org/travis/)        | Linux, macOS          | https://travis-ci.org and https://travis-ci.com                       |

To learn more about CI, read [the "Travis CI for test automation" blog post](http://mahugh.com/2016/09/02/travis-ci-for-test-automation/) and our [Getting Started](https://docs.ropensci.org/tic/articles/tic.html#prerequisites) vignette.

The most important improvements over existing solutions are:

1. Deployment to a Git repository is greatly simplified. Update your repository with results from the CI build.

1. Support for R packages and other kinds of projects (bookdown, blogdown, etc.), with predefined templates.
   Set up your project to deploy rendered versions of your book or blog with a single push to Git.

1. Workflow specification in a single `.R` file, regardless of CI system used.  
   Forget about `.yml` files or web browser configurations.

## Installation

{tic} can be installed from GitHub with:

```r
remotes::install_github("ropensci/tic")
```

## Setup

By calling `tic::use_tic()` a production ready CI setup is initialized, tailored to your specific R project.
The created templates will use the providers https://travis-ci.com (https://travis-ci.org; see [this FAQ](https://docs.ropensci.org/tic/articles/faq.html#q-travis-1) for more info), https://appveyor.com, https://circleci.com and https://github.com/actions.

If only the CI YAML templates from {tic} are desired, the `use_<provider>_yml()` functions can be used.
Refer to [the complete list of options](https://docs.ropensci.org/tic/reference/yaml_templates.html).

For an R package, the following steps will be set up for the CI workflow:

- Installation of required dependencies for the project (by checking the mandatory(!) DESCRIPTION file)
- Satisfying build-time dependencies of steps to be run in all CI stages (by scraping `pkg::fun` calls in `tic.R`)
- Checking of package via `rcmdcheck::rcmdcheck()`
- Creation of a `pkgdown` site including Github deployment
- Running a code coverage and upload to [codecov.io](https://codecov.io/)

See the [Getting Started](https://docs.ropensci.org/tic/articles/tic.html) vignette for more information and links to [minimal example repositories](https://docs.ropensci.org/tic/articles/tic.html#examples-projects) for various R projects (package, blogdown, bookdown and more).

#### Quickstart

If you are a new user, run

```r
tic::use_tic()
```

If you already use {tic} and want to configure a new CI provider, do

```r
## Travis CI
travis::use_travis_deploy() # (optional for deployment)
tic::use_travis_yml(<option here>)
tic::use_tic_r("package", deploy_on = "travis")

## Circle CI
circle::use_circle_deploy() # (optional for deployment)
tic::use_circle_yml(<option here>)
tic::use_tic_r("package", deploy_on = "circle")

## Appveyor
tic::use_appveyor_yml(<option here>)

## Github Actions
tic::use_ghactions_deploy(deploy = TRUE)
tic::use_ghactions_yml(deploy = TRUE)
tic::use_tic_r("package", deploy_on = "ghactions")
tic::use_tic_badge("ghactions")
```

## Good to know

We would like to mention that {tic} is a choice and sits on top of existing community efforts providing R support for various CI providers.
While {tic} will prevent you from dealing/learning every CIs YAML syntax, you will have to learn {tic}'s way of specifying your tasks on CI systems.

Also, there is no way around familiarizing yourself with the basics of CI systems in general.
Without this knowledge, you will also have a hard way understanding {tic}.

We also recommend to take a look at the projects providing the direct R support for each CI system (which {tic} builds upon) to gain a deeper understanding of the whole concept.

## Updating

There is not yet an automated way of updating the templates installed by {tic}, hence you need to manually check every once in a while if changes were made to the templates.
Have a look at the [changelog](https://docs.ropensci.org/tic/news/index.html) for possible changes to YAML templates or watch the commit history of the CI templates you are using.
An update mechanism is on our list (see [issue #194](https://github.com/ropensci/tic/issues/194)) but it may take some time.

## Examples

All examples listed here work with Travis, some work with AppVeyor too.
The badges link to the most recent build of the master branch.

- [tic.blogdown](https://github.com/ropenscilabs/tic.blogdown): Blogs with [_blogdown_](https://bookdown.org/yihui/blogdown/)

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.blogdown/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.blogdown)
  [![Build status](https://ci.appveyor.com/api/projects/status/eyq1syaite6adkbe?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-blogdown)

- [tic.bookdown](https://github.com/ropenscilabs/tic.bookdown): Books with [_bookdown_](https://bookdown.org/)

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.bookdown/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.bookdown)
  [![Build status](https://ci.appveyor.com/api/projects/status/o36uc2jwl9f7k5a3?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-bookdown)

- [tic.covrpage](https://github.com/ropenscilabs/tic.covrpage): Unit test summary report.

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.covrpage/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.covrpage)
  [![Build status](https://ci.appveyor.com/api/projects/status/ugk6yjouleggw5ic?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-covrpage)

- [tic.drat](https://github.com/ropenscilabs/tic.drat): CRAN-like package repositories with [_drat_](http://dirk.eddelbuettel.com/code/drat.html)

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.drat/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.drat)
  [![Build status](https://ci.appveyor.com/api/projects/status/11qom8mm4v7yi85b?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-drat)
  <a href="https://codecov.io/github/ropenscilabs/tic.drat?branch=master"><img src="https://codecov.io/gh/ropenscilabs/tic.drat/branch/master/graph/badge.svg" alt="Coverage Status"/></a></p>

- [tic.figshare](https://github.com/ropenscilabs/tic.figshare): Deploying artifacts to [figshare](https://figshare.com/) (work in progress).

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.figshare/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.figshare)
  [![Build status](https://ci.appveyor.com/api/projects/status/y43b7snnsj4w1av9?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-figshare)

- [tic.package](https://github.com/ropenscilabs/tic.package): R packages with [_pkgdown_](https://pkgdown.r-lib.org/) documentation

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.package/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.package)
  [![Build status](https://ci.appveyor.com/api/projects/status/67qe2j2fyaxgk63i?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-package)
  <a href="https://codecov.io/github/ropenscilabs/tic.package?branch=master"><img src="https://codecov.io/gh/ropenscilabs/tic.package/branch/master/graph/badge.svg" alt="Coverage Status"/></a></p>

- [tic.packagedocs](https://github.com/ropenscilabs/tic.packagedocs): R packages with [_packagedocs_](http://hafen.github.io/packagedocs/) documentation

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.packagedocs/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.packagedocs)
  [![Build status](https://ci.appveyor.com/api/projects/status/9tiufh34a3p34o39?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-packagedocs)
  <a href="https://codecov.io/github/ropenscilabs/tic.packagedocs?branch=master"><img src="https://codecov.io/gh/ropenscilabs/tic.packagedocs/branch/master/graph/badge.svg" alt="Coverage Status"/></a></p>

- [tic.website](https://github.com/ropenscilabs/tic.website): Websites with [_rmarkdown_](https://rmarkdown.rstudio.com/)

  [![Travis build status](https://img.shields.io/travis/ropenscilabs/tic.website/master?logo=travis&style=flat-square&label=Linux)](https://travis-ci.org/ropenscilabs/tic.website)
  [![Build status](https://ci.appveyor.com/api/projects/status/stsc7vkogh1v6w64?svg=true)](https://ci.appveyor.com/project/ropenscilabs/tic-website)

## Vignettes

- [Get started](https://docs.ropensci.org/tic/articles/tic.html)

- [Feature Overview](https://docs.ropensci.org/tic/articles/features.html)

- [The CI Build Lifecycle](https://docs.ropensci.org/tic/articles/build-lifecycle.html)

- [CI Providers](https://docs.ropensci.org/tic/articles/ci-providers.html)

- [CI Client Packages](https://docs.ropensci.org/tic/articles/ci-client-packages.html)

- [Advanced Usage](https://docs.ropensci.org/tic/articles/advanced.html)

- [Deployment](https://docs.ropensci.org/tic/articles/deployment.html)

- [Custom Steps](https://docs.ropensci.org/tic/articles/custom-steps.html)

- [FAQ](https://docs.ropensci.org/tic/articles/faq.html)

## Limitations

The setup functions in this package assume Git as version control system, and GitHub as platform.
Automated setup works best if the project under test is located in the root of the Git repository.
Multi-project repositories are not supported, see [the comment by @jwijffels](https://github.com/ropensci/tic/issues/117#issuecomment-460814990) for guidance to work around this limitation.

---

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
