# Macros

The [DSL](https://docs.ropensci.org/tic/dev/reference/dsl.md) offers a
fine-grained interface to the individual stages of a CI run. Macros are
tic's way of adding several related steps to the relevant stages. All
macros use the `do_` prefix.

The
[`do_package_checks()`](https://docs.ropensci.org/tic/dev/reference/do_package_checks.md)
macro adds default checks for R packages, including installation of
dependencies and running a test coverage analysis.

The
[`do_pkgdown()`](https://docs.ropensci.org/tic/dev/reference/do_pkgdown.md)
macro adds the necessary steps for building and deploying pkgdown
documentation for a package.

The
[`do_blogdown()`](https://docs.ropensci.org/tic/dev/reference/do_blogdown.md)
macro adds the necessary steps for building and deploying a blogdown
blog.

The
[`do_bookdown()`](https://docs.ropensci.org/tic/dev/reference/do_bookdown.md)
macro adds the necessary steps for building and deploying a bookdown
book.

The
[`do_drat()`](https://docs.ropensci.org/tic/dev/reference/do_drat.md)
macro adds the necessary steps for building and deploying a drat
repository to host R package sources.

The
[`do_readme_rmd()`](https://docs.ropensci.org/tic/dev/reference/do_readme_rmd.md)
macro renders an R Markdown README and deploys the rendered README.md
file to Github.
