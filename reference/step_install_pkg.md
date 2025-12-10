# Step: Install packages

These steps are useful if your CI run needs additional packages. Usually
they are declared as dependencies in your `DESCRIPTION`, but it is also
possible to install dependencies manually. By default, binary versions
of packages are installed if possible, even if the CRAN version is
ahead.

A `step_install_deps()` step installs all package dependencies declared
in `DESCRIPTION`, using
[`pak::local_install_dev_deps()`](https://pak.r-lib.org/reference/local_install_dev_deps.html).
This includes upgrading outdated packages.

This step can only be used if a DESCRIPTION file is present in the
repository root.

A `step_install_cran()` step installs one package from CRAN via
[`install.packages()`](https://rdrr.io/r/utils/install.packages.html),
but only if it's not already installed.

A `step_install_github()` step installs one or more packages from GitHub
via
[`pak::pkg_install()`](https://pak.r-lib.org/reference/pkg_install.html),
the packages are only installed if their GitHub version is different
from the locally installed version.

## Usage

``` r
step_install_deps(dependencies = TRUE)

step_install_cran(package = NULL, ...)

step_install_github(repo = NULL, ...)
```

## Arguments

- dependencies:

  What kinds of dependencies to install. Most commonly one of the
  following values:

  - `NA`: only required (hard) dependencies,

  - `TRUE`: required dependencies plus optional and development
    dependencies,

  - `FALSE`: do not install any dependencies. (You might end up with a
    non-working package, and/or the installation might fail.) See
    [Package dependency
    types](https://pak.r-lib.org/reference/package-dependency-types.html)
    for other possible values and more information about package
    dependencies.

- package:

  Package(s) to install

- ...:

  Passed on to
  [`pak::pkg_install()`](https://pak.r-lib.org/reference/pkg_install.html).

- repo:

  Package to install in the "user/repo" format.

## See also

Other steps:
[`step_add_to_drat()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_drat.md),
[`step_add_to_known_hosts()`](https://docs.ropensci.org/tic/dev/reference/step_add_to_known_hosts.md),
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md),
[`step_do_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_do_push_deploy.md),
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md),
[`step_install_ssh_keys()`](https://docs.ropensci.org/tic/dev/reference/step_install_ssh_keys.md),
[`step_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_push_deploy.md),
[`step_run_code()`](https://docs.ropensci.org/tic/dev/reference/step_run_code.md),
[`step_session_info()`](https://docs.ropensci.org/tic/dev/reference/step_session_info.md),
[`step_setup_push_deploy()`](https://docs.ropensci.org/tic/dev/reference/step_setup_push_deploy.md),
[`step_setup_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_setup_ssh.md),
[`step_test_ssh()`](https://docs.ropensci.org/tic/dev/reference/step_test_ssh.md),
[`step_write_text_file()`](https://docs.ropensci.org/tic/dev/reference/step_write_text_file.md)

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("install") %>%
  add_step(step_install_deps())
#> Superclass TicStep has cloneable=FALSE, but subclass InstallDeps has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for InstallDeps.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: install ──────────────────────────────────────────────────────────────
#> ▶ step_install_deps()
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("install") %>%
  add_step(step_install_cran("magick"))
#> Superclass TicStep has cloneable=FALSE, but subclass InstallCRAN has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for InstallCRAN.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: install ──────────────────────────────────────────────────────────────
#> ▶ step_install_cran("magick")
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("install") %>%
  add_step(step_install_github("rstudio/gt"))
#> Superclass TicStep has cloneable=FALSE, but subclass InstallGitHub has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for InstallGitHub.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: install ──────────────────────────────────────────────────────────────
#> ▶ step_install_github("rstudio/gt")
```
