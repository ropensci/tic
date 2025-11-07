# tic: Tasks Integrating Continuously: CI-Agnostic Workflow Definitions

Provides a way to describe common build and deployment workflows for
R-based projects: packages, websites (e.g. blogdown, pkgdown), or data
processing (e.g. research compendia). The recipe is described
independent of the continuous integration tool used for processing the
workflow (e.g. 'GitHub Actions' or 'Circle CI'). This package has been
peer-reviewed by rOpenSci (v0.3.0.9004).

## Details

The
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md)
function prepares a code repository for use with this package. See
[DSL](https://docs.ropensci.org/tic/dev/reference/dsl.md) for an
overview of tic's domain-specific language for defining stages and
steps,
[`step_hello_world()`](https://docs.ropensci.org/tic/dev/reference/step_hello_world.md)
and the links therein for available steps, and
[macro](https://docs.ropensci.org/tic/dev/reference/macro.md) for an
overview over the available macros that bundle several steps.

## See also

Useful links:

- <https://github.com/ropensci/tic>

- Report bugs at <https://github.com/ropensci/tic/issues>

## Author

**Maintainer**: Eli Miller <eli@eli.dev>
([ORCID](https://orcid.org/0000-0002-2127-9456))

Authors:

- Patrick Schratz ([ORCID](https://orcid.org/0000-0003-0748-6624))

- Kirill Müller ([ORCID](https://orcid.org/0000-0002-1416-3412))

- Mika Braginsky <mika.br@gmail.com>

- Karthik Ram <karthik.ram@gmail.com>

- Jeroen Ooms <jeroenooms@gmail.com>

Other contributors:

- Max Held (Max reviewed the package for ropensci, see
  \<https://github.com/ropensci/software-review/issues/305\>)
  \[reviewer\]

- Anna Krystalli (Anna reviewed the package for ropensci, see
  \<https://github.com/ropensci/software-review/issues/305\>)
  \[reviewer\]

- Laura DeCicco (Laura reviewed the package for ropensci, see
  \<https://github.com/ropensci/software-review/issues/305\>)
  \[reviewer\]

- rOpenSci (019jywm96) \[funder\]
