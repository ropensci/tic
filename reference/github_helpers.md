# Github API helpers

- `auth_github()`: Creates a `GITHUB_TOKEN` and asks to store it in your
  `.Renviron` file.

&nbsp;

- `get_owner()`: Returns the owner of a Github repo.

&nbsp;

- `get_repo()`: Returns the repo name of a Github repo for a given
  remote.

&nbsp;

- `get_repo_slug()`: Returns the repo slug of a Github repo
  (`<owner>/<repo>`).

## Usage

``` r
auth_github()

get_owner(remote = "origin")

get_user()

get_repo(remote = "origin")

get_repo_slug(remote = "origin")
```

## Arguments

- remote:

  `[string]`  
  The Github remote which should be used. Defaults to "origin".
