# Step: Build a bookdown book

Build a bookdown book using
[`bookdown::render_book()`](https://pkgs.rstudio.com/bookdown/reference/render_book.html).

## Usage

``` r
step_build_bookdown(...)
```

## Arguments

- ...:

  See
  [bookdown::render_book](https://pkgs.rstudio.com/bookdown/reference/render_book.html).

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("script") %>%
  add_step(step_build_bookdown("."))
#> Superclass TicStep has cloneable=FALSE, but subclass BuildBookdown has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for BuildBookdown.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_build_bookdown(".")
```
