# Emulate a CI run locally

Runs predefined
[stages](https://docs.ropensci.org/tic/dev/reference/stages.md)
similarly to the chosen CI provider. The run aborts on error, the
`after_failure` stage is never run.

## Usage

``` r
run_all_stages(stages = dsl_load())
```

## Arguments

- stages:

  `[named list]` A named list of `TicStage` objects as returned by
  [`dsl_load()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md),
  by default loaded from `tic.R`.

## Details

The stages are run in the following order:

1.  [`before_install()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

2.  [`install()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

3.  [`after_install()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

4.  [`before_script()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

5.  [`script()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

6.  [`after_success()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

7.  [`before_deploy()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

8.  [`deploy()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

9.  [`after_deploy()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

10. [`after_script()`](https://docs.ropensci.org/tic/dev/reference/stages.md)

## See also

Other runners:
[`prepare_all_stages()`](https://docs.ropensci.org/tic/dev/reference/prepare_all_stages.md),
[`run_stage()`](https://docs.ropensci.org/tic/dev/reference/run_stage.md)
