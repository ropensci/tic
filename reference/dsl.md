# tic's domain-specific language

Functions to define stages and their constituent steps. The
[macro](https://docs.ropensci.org/tic/dev/reference/macro.md)s combine
several steps and assign them to relevant stages. See
[`dsl_get()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md)
for functions to access the storage for the stages and their steps.

`get_stage()` returns a `TicStage` object for a stage given by name.
This function can be called directly in the `tic.R` configuration file,
which is processed by
[`dsl_load()`](https://docs.ropensci.org/tic/dev/reference/dsl_get.md).

`add_step()` adds a step to a stage, see
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md)
and the links therein for available steps.

`add_code_step()` is a shortcut for `add_step(step_run_code(...))`.

## Usage

``` r
get_stage(name)

add_step(stage, step)

add_code_step(stage, call = NULL, prepare_call = NULL)
```

## Arguments

- name:

  `[string]`  
  The name for the stage.

- stage:

  `[TicStage]`  
  A `TicStage` object as returned by `get_stage()`.

- step:

  `[function]`  
  An object of class
  [TicStep](https://docs.ropensci.org/tic/dev/reference/TicStep.md),
  usually created by functions with the `step_` prefix like
  [`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md).

- call:

  `[call]`  
  An arbitrary R expression executed during the stage to which this step
  is added. The default is useful if you only pass `prepare_call`.

- prepare_call:

  `[call]`  
  An optional arbitrary R expression executed during preparation.

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("script")
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ℹ No steps defined

get_stage("script") %>%
  add_step(step_hello_world())
#> Superclass TicStep has cloneable=FALSE, but subclass HelloWorld has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for HelloWorld.

get_stage("script")
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_hello_world()

get_stage("script") %>%
  add_code_step(print("Hi!"))
#> Superclass TicStep has cloneable=FALSE, but subclass RunCode has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for RunCode.

get_stage("script")
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_hello_world()
#> ▶ step_run_code(print("Hi!"))
```
