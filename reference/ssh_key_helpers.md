# SSH key helpers

SSH key helpers

## Usage

``` r
github_add_key(
  pubkey,
  repo = get_repo(remote),
  user = get_user(),
  title = "ghactions",
  remote = "origin",
  check_role = TRUE
)

check_admin_repo(owner, user, repo)

get_role_in_repo(owner, user, repo)

get_public_key(key)

encode_private_key(key)

check_private_key_name(string)
```

## Arguments

- pubkey:

  The public key of the SSH key pair

- repo:

  `[string]`  
  The repository slug to use. Must follow the "`user/repo`" structure.

- user:

  The name of the user account

- title:

  The title of the key to add

- remote:

  `[string]`  
  The Github remote which should be used. Defaults to "origin".

- check_role:

  Whether to check if the current user has the permissions to add a key
  to the repo. Setting this to `FALSE` makes it possible to add keys to
  other repos than just the one from which the function is called.

- owner:

  The owner of the repository

- key:

  The SSH key pair object

- string:

  String to check
