# Github information

`github_repo()` returns the true repository name as string.

Retrieves metadata about a Git repository from GitHub.

`github_info()` returns a list as obtained from the GET "/repos/:repo"
API.

## Usage

``` r
github_repo(
  path = usethis::proj_get(),
  info = github_info(path, remote = remote),
  remote = "origin"
)

github_info(path = usethis::proj_get(), remote = "origin")

uses_github(path = usethis::proj_get())
```

## Arguments

- path:

  `[string]`  
  The path to a GitHub-enabled Git repository (or a subdirectory
  thereof).

- info:

  `[list]`  
  GitHub information for the repository, by default obtained through
  `github_info()`.

- remote:

  `[string]`  
  The Github remote which should be used. Defaults to "origin".
