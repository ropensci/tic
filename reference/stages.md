# Predefined stages

Stages available in the CI provider, for which shortcuts have been
defined. All these functions call
[`run_stage()`](https://docs.ropensci.org/tic/dev/reference/run_stage.md)
with the corresponding stage name.

## Usage

``` r
before_install(stages = dsl_load())

install(stages = dsl_load())

after_install(stages = dsl_load())

before_script(stages = dsl_load())

script(stages = dsl_load())

after_success(stages = dsl_load())

after_failure(stages = dsl_load())

before_deploy(stages = dsl_load())

deploy(stages = dsl_load())

after_deploy(stages = dsl_load())

after_script(stages = dsl_load())
```

## Arguments

- stages:

  `[named list]` A named list of `TicStage` objects as returned by
  [`dsl_load()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md),
  by default loaded from `tic.R`.
