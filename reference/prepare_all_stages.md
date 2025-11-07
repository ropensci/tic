# Prepare all stages

Run the `prepare()` method for all defined steps for which the `check()`
method returns `TRUE`.

## Usage

``` r
prepare_all_stages(stages = dsl_load())
```

## Arguments

- stages:

  `[named list]` A named list of `TicStage` objects as returned by
  [`dsl_load()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md),
  by default loaded from `tic.R`.

## See also

[TicStep](https://docs.ropensci.org/tic/dev/reference/TicStep.md)

Other runners:
[`run_all_stages()`](https://docs.ropensci.org/tic/dev/reference/run_all_stages.md),
[`run_stage()`](https://docs.ropensci.org/tic/dev/reference/run_stage.md)
