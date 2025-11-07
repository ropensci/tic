# Step: Build a Blogdown Site

Build a Blogdown site using
[`blogdown::build_site()`](https://pkgs.rstudio.com/blogdown/reference/build_site.html).

## Usage

``` r
step_build_blogdown(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`blogdown::build_site`](https://pkgs.rstudio.com/blogdown/reference/build_site.html)

  `local`

  :   Whether to build the website locally. This argument is passed to
      [`hugo_build()`](https://pkgs.rstudio.com/blogdown/reference/hugo_cmd.html),
      and `local = TRUE` is mainly for serving the site locally via
      [`serve_site()`](https://pkgs.rstudio.com/blogdown/reference/serve_site.html).

  `run_hugo`

  :   Whether to run `hugo_build()` after R Markdown files are compiled.

  `build_rmd`

  :   Whether to (re)build R Markdown files. By default, they are not
      built. See ‘Details’ for how `build_rmd = TRUE` works.
      Alternatively, it can take a vector of file paths, which means
      these files are to be (re)built. Or you can provide a function
      that takes a vector of paths of all R Markdown files under the
      `content/` directory, and returns a vector of paths of files to be
      built, e.g., `build_rmd = blogdown::filter_timestamp`. A few
      aliases are currently provided for such functions:
      `build_rmd = 'newfile'` is equivalent to
      `build_rmd = blogdown::filter_newfile`, `build_rmd = 'timestamp'`
      is equivalent to `build_rmd = blogdown::filter_timestamp`, and
      `build_rmd = 'md5sum'` is equivalent to
      `build_rmd = blogdown::filter_md5sum`.

## Examples

``` r
dsl_init()
#> ✔ Creating a clean tic stage configuration
#> ℹ See `?tic::dsl_get` for details

get_stage("script") %>%
  add_step(step_build_blogdown("."))
#> Superclass TicStep has cloneable=FALSE, but subclass BuildBlogdown has cloneable=TRUE. A subclass cannot be cloneable when its superclass is not cloneable, so cloning will be disabled for BuildBlogdown.

dsl_get()
#> ── tic configuration summary ───────────────────────────────────────────────────
#> ── Stage: script ───────────────────────────────────────────────────────────────
#> ▶ step_build_blogdown(".")
```
