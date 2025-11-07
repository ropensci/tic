# Run a stage

Run the `run_all()` method for all defined steps of a stage for which
the `check()` method returns `TRUE`.

## Usage

``` r
run_stage(name, stages = dsl_load())
```

## Arguments

- name:

  `[string]`  
  The name of the stage to run.

- stages:

  `[named list]` A named list of `TicStage` objects as returned by
  [`dsl_load()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md),
  by default loaded from `tic.R`.

## See also

[TicStep](https://docs.ropensci.org/tic/dev/reference/TicStep.md)

Other runners:
[`prepare_all_stages()`](https://docs.ropensci.org/tic/dev/reference/prepare_all_stages.md),
[`run_all_stages()`](https://docs.ropensci.org/tic/dev/reference/run_all_stages.md)
