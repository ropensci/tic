# Stages and steps

tic works in a declarative way, centered around the `tic.R` file created
by
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md).
This file contains the *definition* of the steps to be run in each
stage: calls to
[`get_stage()`](https://docs.ropensci.org/tic/dev/reference/dsl.md) and
[`add_step()`](https://docs.ropensci.org/tic/dev/reference/dsl.md), or
macros like
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md).

Normally, this file is never executed directly. Running these functions
in an interactive session will **not** carry out the respective actions.
Instead, a description of the code that would have been run is printed
to the console. Edit `tic.R` to configure your CI builds. See
[`vignette("build-lifecycle", package = "tic")`](https://docs.ropensci.org/tic/dev/articles/build-lifecycle.md)
for more details.

## Usage

``` r
dsl_get()

dsl_load(path = "tic.R", force = FALSE, quiet = FALSE)

dsl_init(quiet = FALSE)
```

## Arguments

- path:

  `[string]`  
  Path to the stage definition file, default: `"tic.R"`.

- force:

  `[flag]`  
  Set to `TRUE` to force loading from file even if a configuration
  exists. By default an existing configuration is not overwritten by
  `dsl_load()`.

- quiet:

  `[flag]`  
  Set to `TRUE` to turn off verbose output.

## Value

A named list of opaque stage objects with a `"class"` attribute and a
corresponding [`print()`](https://rdrr.io/r/base/print.html) method for
pretty output. Use the high-level
[`get_stage()`](https://docs.ropensci.org/tic/dev/reference/dsl.md) and
[`add_step()`](https://docs.ropensci.org/tic/dev/reference/dsl.md)
functions to configure, and the
[stages](https://docs.ropensci.org/tic/dev/reference/stages.md)
functions to run.

## Details

Stages and steps defined using tic's
[DSL](https://docs.ropensci.org/tic/dev/reference/dsl.md) are stored in
an internal object in the package. The stages are accessible through
`dsl_get()`. When running the
[stages](https://docs.ropensci.org/tic/dev/reference/stages.md), by
default a configuration defined in the `tic.R` file is loaded with
`dsl_load()`. See
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)
for setting up a `tic.R` file.

For interactive tests, an empty storage can be initialized with
`dsl_init()`. This happens automatically the first time `dsl_get()` is
called (directly or indirectly).

## Examples

``` r
if (FALSE) { # \dontrun{
dsl_init()
dsl_get()

dsl_load(system.file("templates/package/tic.R", package = "tic"))
dsl_load(system.file("templates/package/tic.R", package = "tic"),
  force =
    TRUE
)
dsl_get()
} # }
```
