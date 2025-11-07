# Update tic YAML Templates

Updates YAML templates to their latest versions. Currently only GitHub
Actions and Circle CI templates are supported.

## Usage

``` r
update_yml(template_in = NULL, template_out = NULL)
```

## Arguments

- template_in:

  `[character]`  
  Path to template which should be updated. By default all standard
  template paths of GitHub Actions or Circle CI will be searched and
  updated if they exist. Alternatively a full path to a single template
  can be passed.

- template_out:

  `[character]`  
  Where the updated template should be written to. This is mainly used
  for internal testing purposes and should not be set by the user.

## Details

By default all workflow files starting with `tic` are matched. This
means that you can have multiple YAML files with update support, e.g.
`"tic.yml"` and `"tic-db.yml"`.

## Formatting requirements of tic YAML templates

To ensure that updating of 'tic' templates works, ensure the following
points:

- Your template contains the type (e.g. linux-matrix-deploy) and the
  revision date in its first two lines.

- When inserting comments into custom code blocks, only one-line
  comments are allowed. Otherwise the update heuristic gets in trouble.

## See also

yaml_templates

## Examples

``` r
if (FALSE) { # \dontrun{
# auto-search
update_yml()

update_yml("tic.yml")

# custom named templates
update_yml("custom-name.yml")

# full paths
update_yml("~/path/to/repo/.github/workflows/tic.yml")
} # }
```
