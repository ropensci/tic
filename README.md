# tic

<!-- badges: start -->

[![tic](https://github.com/ropensci/tic/workflows/tic/badge.svg?branch=master)](https://github.com/ropensci/tic/actions)
[![CircleCI](https://img.shields.io/circleci/build/gh/ropensci/tic/master?label=Linux&logo=circle&logoColor=green&style=flat-square)](https://circleci.com/gh/ropensci/tic)
[![CRAN status](https://www.r-pkg.org/badges/version/tic)](https://cran.r-project.org/package=tic)
[![codecov](https://codecov.io/gh/ropensci/tic/branch/master/graph/badge.svg)](https://codecov.io/gh/ropensci/tic)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![tic status badge](https://ropensci.r-universe.dev/badges/tic)](https://ropensci.r-universe.dev)
[![](https://badges.ropensci.org/305_status.svg)](https://github.com/ropensci/software-review/issues/305)
<!-- badges: end -->

The goal of tic is to enhance and simplify working with continuous integration (CI) systems.

The following providers are supported:

| Provider       | R package                                     | Platforms             | Info                                                                  |
| -------------- | --------------------------------------------- | --------------------- | --------------------------------------------------------------------- |
| Circle CI      | [{circle}](https://docs.ropensci.org/circle/) | Linux                 | via Docker images from [rocker](https://github.com/rocker-org/rocker) |
| Github Actions | [{ghactions}](https://maxheld.de/ghactions)   | Linux, macOS, Windows |                                                                       |

In addition there is partial support for [Drone CI](drone.io) via class `DRONE_CI`.
This means that {tic} recognizes Drone CI as a CI platform and does not exit early or requires setting a fake env var to mimic another CI provider.
However, there is neither an R client package for Drone CI currently nor {tic} templates available for bootstrapping CI configuration via `tic::use_tic()`.

To learn more about CI, read our [Getting Started](https://docs.ropensci.org/tic/articles/tic.html#prerequisites) vignette.

The most important improvements over existing solutions are:

1. Deployment to a Git repository is greatly simplified. Update your repository with results from the CI build.

2. Support for R packages and other kinds of projects (bookdown, blogdown, etc.), with predefined templates.
   Set up your project to deploy rendered versions of your book or blog with a single push to Git.

3. Workflow specification in a single `.R` file, regardless of CI system used.
   Forget about `.yml` files or web browser configurations.

## Installation

{tic} can be installed from GitHub with:

```r
remotes::install_github("ropensci/tic")
```

## Setup

By calling `tic::use_tic()` a production ready CI setup is initialized, tailored to your specific R project.
The created templates will use the providers [Circle CI](https://circleci.com) and [Github Actions](https://github.com/actions).

If only the CI YAML templates from {tic} are desired, the `use_<provider>_yml()` functions can be used.
Refer to [the complete list of options](https://docs.ropensci.org/tic/reference/yaml_templates.html).

For an R package, the following steps will be set up for the CI workflow:

- Installation of required dependencies for the project (dependencies are scraped from the DESCRIPTION file\*)
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

If you already use {tic} and want to configure a new CI provider, do one of the following (depending on your preferred CI provider)

```r
### Circle CI ------------------------------------------------------------------

circle::use_circle_deploy() # (optional for deployment)
tic::use_circle_yml() # optional: Change `type` arg to your liking
tic::use_tic_r("package", deploy_on = "circle")
# (all of the above in one call)
# tic::use_tic(wizard = FALSE, linux = "circle", mac = "none", windows = "none",
#              matrix = "circle", deploy = "circle")
tic::use_update_tic()

### GitHub Actions -------------------------------------------------------------

tic::use_ghactions_deploy() # (optional for deployment)
tic::use_ghactions_yml() # optional: Change `type` arg to your liking
tic::use_tic_r("package", deploy_on = "ghactions")
# (all of the above in one call)
# tic::use_tic(wizard = FALSE, linux = "ghactions", mac = "ghactions",
#              windows = "ghactions", matrix = "ghactions", deploy = "ghactions")

tic::use_tic_badge("ghactions")
tic::use_update_tic()
```

## Good to know

We would like to mention that {tic} is a choice and sits on top of existing community efforts providing R support for various CI providers.
While {tic} will prevent you from dealing/learning every CIs YAML syntax, you will have to learn {tic}'s way of specifying your tasks on CI systems.

Also, there is no way around familiarizing yourself with the basics of CI systems in general.
Without this knowledge, you will also have a hard way understanding {tic}.

We also recommend to take a look at the projects providing the direct R support for each CI system (which {tic} builds upon) to gain a deeper understanding of the whole concept.

## Updating

Updating of YAML templates is supported via [`update_yml()`](https://docs.ropensci.org/tic/reference/update_yml.html).
See vignette ["Updating Templates"](https://docs.ropensci.org/tic/articles/updating.html) for more information.

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

The DESCRIPTION files needs to live in the project root.
 To simplify its creation have a look at [usethis::use_package()](https://usethis.r-lib.org/reference/use_package.html) or [usethis::use_description()](https://usethis.r-lib.org/reference/use_description.html).
