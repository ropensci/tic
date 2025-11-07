# The base class for all steps

Override this class to create a new step.

## Methods

### Public methods

- [`TicStep$new()`](#method-TicStep-new)

- [`TicStep$run()`](#method-TicStep-run)

- [`TicStep$prepare()`](#method-TicStep-prepare)

- [`TicStep$check()`](#method-TicStep-check)

------------------------------------------------------------------------

### Method `new()`

Create a `TicStep` object.

#### Usage

    TicStep$new()

------------------------------------------------------------------------

### Method `run()`

This method must be overridden, it is called when running the stage to
which a step has been added.

#### Usage

    TicStep$run()

------------------------------------------------------------------------

### Method `prepare()`

This is just a placeholder. This method is called when preparing the
stage to which a step has been added. It auto-install all packages which
are needed for a certain step. For example,
[`step_build_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/step_build_pkgdown.md)
requires the *pkgdown* package.

For
[`add_code_step()`](https://docs.ropensci.org/tic/dev/reference/dsl.md),
it autodetects any package calls in the form of `pkg::fun` and tries to
install these packages from CRAN. If a steps `prepare_call` is not
empty, the `$prepare` method is skipped for this step. This can be
useful if a package should be installed from non-standard repositories,
e.g. from GitHub.

#### Usage

    TicStep$prepare()

------------------------------------------------------------------------

### Method `check()`

This method determines if a step is prepared and run. Return `FALSE` if
conditions for running this step are not met.

#### Usage

    TicStep$check()
