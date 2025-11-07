# Use CI YAML templates

Installs YAML templates for various CI providers. These functions are
also used within
[`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md).

If you want to update an existing template use
[`update_yml()`](https://docs.ropensci.org/tic/dev/reference/update_yml.md).

## Usage

``` r
use_circle_yml(type = "linux-deploy", write = TRUE, quiet = FALSE)

use_ghactions_yml(type = "linux-deploy", write = TRUE, quiet = FALSE)
```

## Arguments

- type:

  `[character]`  
  Which template to use. The string should be given following the logic
  `<platform>-<action>`. See details for more.

- write:

  `[logical]`  
  Whether to write the template to disk (`TRUE`) or just return it
  (`FALSE`).

- quiet:

  `[logical]`  
  Whether to print informative messages.

## pkgdown

If `type` contains "deploy", tic by default also sets the environment
variable `BUILD_PKGDOWN=true`. This triggers a call to
[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html)
via the `do_pkgdown` macro in `tic.R` for the respective runners.

If a setting includes "matrix" and builds on multiple R versions, the
job building on R release is chosen to build the pkgdown site.

## YAML Type

`tic` supports a variety of different YAML templates which follow the
`<platform>-<action>` pattern. The first one is mandatory, the others
are optional.

- Possible values for `<platform>` are `linux`, and `macos`, `windows`.

- Possible values for `<action>` are `matrix` and `deploy`.

Special types are `custom` and `custom-deploy`. These should be used if
the runner matrix is completely user-defined. This is mainly useful in
[`update_yml()`](https://docs.ropensci.org/tic/dev/reference/update_yml.md).

For backward compatibility `use_ghactions_yml()` will be default build
and deploy on all platforms.

Here is a list of all available combinations:

|            |                         |            |                     |                                                   |
|------------|-------------------------|------------|---------------------|---------------------------------------------------|
| Provider   | Operating system        | Deployment | multiple R versions | Call                                              |
| Circle     | Linux                   | no         | no                  | `use_circle_yml("linux")`                         |
|            | Linux                   | yes        | no                  | `use_circle_yml("linux-deploy")`                  |
|            | Linux                   | no         | yes                 | `use_circle_yml("linux-matrix")`                  |
|            | Linux                   | no         | yes                 | `use_circle_yml("linux-deploy-matrix")`           |
| ———-       | ————————                | ———-       | ——————-             | ——————————————————-                               |
| GH Actions | Linux                   | no         | no                  | `use_ghactions_yml("linux")`                      |
|            | Linux                   | yes        | no                  | `use_ghactions_yml("linux-deploy")`               |
|            | custom                  | no         | no                  | `use_ghactions_yml("custom")`                     |
|            | custom-deploy           | yes        | no                  | `use_ghactions_yml("custom-deploy")`              |
|            | macOS                   | no         | no                  | `use_ghactions_yml("macos")`                      |
|            | macOS                   | yes        | no                  | `use_ghactions_yml("macos-deploy")`               |
|            | Windows                 | no         | no                  | `use_ghactions_yml("windows")`                    |
|            | Windows                 | yes        | no                  | `use_ghactions_yml("windows-deploy")`             |
|            | Linux + macOS           | no         | no                  | `use_ghactions_yml("linux-macos")`                |
|            | Linux + macOS           | yes        | no                  | `use_ghactions_yml("linux-macos-deploy")`         |
|            | Linux + Windows         | no         | no                  | `use_ghactions_yml("linux-windows")`              |
|            | Linux + Windows         | yes        | no                  | `use_ghactions_yml("linux-windows-deploy")`       |
|            | macOS + Windows         | no         | no                  | `use_ghactions_yml("macos-windows")`              |
|            | macOS + Windows         | yes        | no                  | `use_ghactions_yml("macos-windows-deploy")`       |
|            | Linux + macOS + Windows | no         | no                  | `use_ghactions_yml("linux-macos-windows")`        |
|            | Linux + macOS + Windows | yes        | no                  | `use_ghactions_yml("linux-macos-windows-deploy")` |
