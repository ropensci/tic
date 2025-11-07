# The current CI environment

Functions that return environment settings that describe the CI
environment. The value is retrieved only once and then cached.

`ci_get_branch()`: Returns the current branch. Returns nothing if
operating on a tag.

`ci_is_tag()`: Returns the current tag name. Returns nothing if a branch
is selected.

`ci_get_slug()`: Returns the repo slug in the format `user/repo` or
`org/repo`

`ci_get_build_number()`: Returns the CI build number.

`ci_get_build_url()`: Returns the URL of the current build.

`ci_get_commit()`: Returns the SHA1 of the current commit.

`ci_get_env()`: Return an environment or configuration variable.

`ci_is_env()`: Checks if an environment or configuration variable is set
to a particular value.

`ci_has_env()`: Checks if an environment or configuration variable is
set to any value.

`ci_can_push()`: Checks if push deployment is possible. Always true for
local environments, CI environments require an environment variable (by
default `TIC_DEPLOY_KEY`).

`ci_is_interactive()`: Returns whether the current build is run
interactively or not. Global setup operations shouldn't be run on
interactive CIs.

`ci_cat_with_color()`: Colored output targeted to the CI log. The code
argument can be an unevaluated call to a crayon function, the style will
be applied even if it normally wouldn't be.

`ci_on_circle()`: Are we running on Circle CI?

`ci_on_ghactions()`: Are we running on GitHub Actions?

`ci()`: Return the current CI environment

## Usage

``` r
ci_get_branch()

ci_is_tag()

ci_get_slug()

ci_get_build_number()

ci_get_build_url()

ci_get_commit()

ci_get_env(env)

ci_is_env(env, value)

ci_has_env(env)

ci_can_push(private_key_name = "TIC_DEPLOY_KEY")

ci_is_interactive()

ci_cat_with_color(code)

ci_on_circle()

ci_on_ghactions()

ci()
```

## Arguments

- env:

  Name of the environment variable to check.

- value:

  Value for the environment variable to compare against.

- private_key_name:

  `string`  
  Only needed when deploying from builds on GitHub Actions. If you have
  set a custom name for the private key during creation of the SSH key
  pair via tic::use_ghactions_deploy()\] or
  [`use_tic()`](https://docs.ropensci.org/tic/dev/reference/use_tic.md),
  pass this name here.

- code:

  Code that should be colored.
