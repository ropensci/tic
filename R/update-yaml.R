#' @title Update tic YAML Templates
#' @description Updates YAML templates to their
#'   latest versions. Currently only GitHub Actions and Circle CI templates are
#'   supported.
#'
#' @details By default all workflow files starting with `tic` are matched. This
#'   means that you can have multiple YAML files with update support, e.g.
#'   `"tic.yml"` and `"tic-db.yml"`.
#'
#' @section Formatting requirements of tic YAML templates: To ensure that
#'   updating of {tic} templates works, ensure the following points:
#' - Your template contains the type (e.g. linux-matrix-deploy) and the revision
#' date in its first two lines.
#' - When inserting comments into custom code blocks, only one-line comments are
#' allowed. Otherwise the update heuristic gets in trouble.
#'
#' @param template_in `[character]`\cr
#'   Path to template which should be updated. By default all standard template
#'   paths of GitHub Actions or Circle CI will be searched and
#'   updated if they exist. Alternatively a full path to a single template can
#'   be passed.
#' @param template_out `[character]`\cr
#'   Where the updated template should be written to. This is mainly used for
#'   internal testing purposes and should not be set by the user.
#'
#' @examples
#' \dontrun{
#' # auto-search
#' update_yml()
#'
#' update_yml("tic.yml")
#'
#' # custom named templates
#' update_yml("custom-name.yml")
#'
#' # full paths
#' update_yml("~/path/to/repo/.github/workflows/tic.yml")
#' }
#' @seealso yaml_templates
#' @export
update_yml <- function(template_in = NULL,
                       template_out = NULL) {

  # by default all templates will be updated that can be found
  if (is.null(template_in)) {
    # check for existences of circle-ci/config.yml and tic.yml
    tic_ymls <- list.files(usethis::proj_path(".github/workflows"),
      pattern = "^tic*", full.names = TRUE
    )
    if (length(tic_ymls) > 0) {
      ghactions <- tic_ymls
    } else {
      # account for old main.yml default
      if (file.exists(usethis::proj_path(".github/workflows", "main.yml"))) {
        ghactions <- usethis::proj_path(".github/workflows", "main.yml")
      } else {
        ghactions <- NULL
      }
    }
    if (file.exists(usethis::proj_path(".circleci/", "config.yml"))) {
      circle <- usethis::proj_path(".circleci", "config.yml")
    } else {
      circle <- NULL
    }
    providers <- c(ghactions, circle)
  } else {
    providers <- template_in
  }

  for (instance in providers) {
    instance_txt <- readLines(instance)

    # by default overwrite the current template.
    if (is.null(template_out)) {
      template_out <- instance
    }
    # read date of local template to compare against upstream template date

    # need a tryCatch() to protect against errors from as.Date()
    rev_date_local <- tryCatch(as.character(gsub(
      ".*(\\d{4}-\\d{2}-\\d{2}).*", "\\1",
      instance_txt[2]
    )),
    error = function(cond) {
      return(NA)
    }
    )
    if (is.na(rev_date_local)) {
      cli::cli_alert_warning("{.file {basename(instance)}} does not (yet)
      contain a (valid) {.pkg tic} revision date (format: YYYY-MM-DD).
      If {.file {basename(instance)}} is managed by {.pkg tic}, please update
      the template manually one last time or manually add a revision date
      into the template as the first line of your template.
      Otherwise ignore this message.",
        wrap = TRUE
      )
      cli::cli_alert("Skipping {.file {basename(instance)}}")
      # reset template_out
      template_out <- NULL
      # skip to next iteration
      next
    }

    # find template type
    tmpl_type <- stringr::str_split(instance_txt[1], "template: ",
      simplify = TRUE
    )[, 2]
    # get ci provider information
    ci_provider <- stringr::str_extract_all(instance_txt[1],
      "(?<=tic ).+(?= template)",
      simplify = TRUE
    )[1, 1]

    tmpl_latest <- switch(ci_provider,
      "GitHub Actions" = use_ghactions_yml(tmpl_type,
        write = FALSE,
        quiet = TRUE
      ),
      "Circle CI" = use_circle_yml(tmpl_type, write = FALSE, quiet = TRUE)
    )
    # get revision date from upstream template
    rev_date_latest <- as.character(gsub(
      ".*(\\d{4}-\\d{2}-\\d{2}).*", "\\1",
      tmpl_latest[2]
    ), quiet = TRUE)

    if (!rev_date_latest > rev_date_local) {
      cli::cli_alert_info(
        "{.file {basename(instance)}}: You already have the latest version of
        the {ci_provider} template ({rev_date_latest}).",
        wrap = TRUE
      )
      template_out <- NULL
      next
    } else {
      cli::cli_alert("Updating {ci_provider} template
        {.file {basename(instance)}} from version
        {.field {rev_date_local}} to version {.field {rev_date_latest}}.", wrap = TRUE)
    }

    # call internal update function for each provider
    tmpl_latest <- switch(ci_provider,
      "GitHub Actions" = update_ghactions_yml(instance_txt, tmpl_latest),
      "Circle CI"      = update_circle_yml(instance_txt, tmpl_latest)
    )

    cli::cli_alert_info("Writing {.file {template_out}}.")
    cli::cli_par()
    cli::cli_end()
    writeLines(tmpl_latest, template_out)

    # reset template_out
    template_out <- NULL
  }
  return(TRUE)
}

update_ghactions_yml <- function(tmpl_local, tmpl_latest) {

  # update matrix names -------------------------------------------------------

  custom_matrix_matrix_name <- stringr::str_which(
    tmpl_local,
    "#.\\[Custom matrix name"
  )
  if (length(custom_matrix_matrix_name) > 0) {
    cli::cli_alert_info("Found {.val {length(custom_matrix_matrix_name)}}
      custom matrix name variable{?s}.", wrap = TRUE)
    # find env var section in latest template (adding +1 to skip the comment)
    matrix_name_index_latest <- stringr::str_which(
      tmpl_latest,
      "name: \\$\\{\\{ matrix"
    )

    custom_matrix_matrix_name_list <- purrr::map(custom_matrix_matrix_name, ~ {
      tmpl_local[.x:(.x + 1)]
    })

    for (i in seq_along(custom_matrix_matrix_name_list)) {
      tmpl_latest <- replace(
        tmpl_latest,
        c(matrix_name_index_latest:(matrix_name_index_latest + 1)),
        custom_matrix_matrix_name_list[[i]]
      )
      tmpl_latest <- append(tmpl_latest, "",
        after = matrix_name_index_latest + 1
      )
    }
  }

  # update matrix env vars -----------------------------------------------------

  custom_matrix_env_vars <- stringr::str_which(
    tmpl_local,
    "#.\\[Custom matrix env var"
  )
  if (length(custom_matrix_env_vars) > 0) {
    cli::cli_alert_info("Found {.val {length(custom_matrix_env_vars)}} custom
      matrix env variable{?s}.", wrap = TRUE)
    # find env var section in latest template (adding +1 to skip the comment)
    matrix_env_var_index_latest <- stringr::str_which(
      tmpl_latest,
      "config:"
    ) + 1

    custom_matrix_env_var_list <- purrr::map(custom_matrix_env_vars, ~ {
      tmpl_local[.x:(.x + 1)]
    })

    for (i in seq_along(custom_matrix_env_var_list)) {
      tmpl_latest <- append(tmpl_latest,
        custom_matrix_env_var_list[[i]],
        after = matrix_env_var_index_latest
      )
    }
  }

  # update env vars ------------------------------------------------------------

  # find the line IDs of all custom env vars
  # env vars need to be prefixed with a comment including [Custom]
  custom_env_vars <- stringr::str_which(tmpl_local, "#.\\[Custom env")

  if (length(custom_env_vars) > 0) {
    cli::cli_alert_info("Found {.val {length(custom_env_vars)}} custom env
      variable{?s}.", wrap = TRUE)
    # find env var section in latest template
    env_var_index_latest <- stringr::str_which(tmpl_latest, "env:")

    custom_env_var_list <- purrr::map(custom_env_vars, ~ {
      tmpl_local[.x:(.x + 1)]
    })

    for (i in seq_along(custom_env_var_list)) {
      tmpl_latest <- append(tmpl_latest,
        custom_env_var_list[[i]],
        after = env_var_index_latest
      )
    }
    # see update-yaml-helpers.R
    tmpl_latest <- account_for_dup_env_vars(
      custom_env_var_list,
      env_var_index_latest,
      tmpl_latest
    )
  }

  # update user blocks ---------------------------------------------------------

  # find the line IDs of all custom user blocks
  custom_blocks_start <- stringr::str_which(
    tmpl_local,
    'name: "\\[Custom block'
  )

  if (length(custom_blocks_start > 0)) {
    cli::cli_alert_info("Found {.val {length(custom_blocks_start)}} custom user
                        block{?s}.", wrap = TRUE)

    # find all blank lines so we know when blocks end
    stringr::str_which(tmpl_local, "^\\s*$")

    # Create list storing all custom user blocks
    # User blocks need to start with "[Custom]"
    custom_blocks_list <- purrr::map(custom_blocks_start, ~ {
      # find the line number of the respective block
      block_end <- purrr::keep(
        # find all blank lines so we know when blocks end and subtract one from
        # the ID
        stringr::str_which(tmpl_local, "^\\s*$"),
        function(y) y > .x
      )[1] - 1
      # append an empty newline here for spacing between blocks when writing to
      # disk later
      append(tmpl_local[.x:block_end], "")
    })

    # find all block names of previous blocks to have an anchor for later when
    # inserting

    # List of blocks after which the custom user blocks appear
    tmpl_blocks_names <- purrr::map_chr(custom_blocks_start, ~ {
      # find the line number of the respective block
      row_inds_prev_temp_block <- tail(purrr::keep(
        # row IDs of all blocks starting with "- name"
        stringr::str_which(tmpl_local, "- name"),
        function(y) y < .x
      ), n = 1)
      # get the "name" of the previous block
      purrr::map_chr(row_inds_prev_temp_block, ~
      stringr::str_extract(tmpl_local[.x], "-.*"))
    })

    tmpl_blocks_names <- purrr::map_chr(custom_blocks_start, ~ {
      # find the line number of the respective block
      row_inds_prev_temp_block <- tail(purrr::keep(
        # row IDs of all blocks starting with "- name" but not followed by
        # [Custom ] (regex: negative lookahead)
        stringr::str_which(tmpl_local, "- name: (?!\"\\[Custom)"),
        function(y) y < .x
      ), n = 1)
      # get the "name" of the previous block
      purrr::map_chr(row_inds_prev_temp_block, ~
      stringr::str_extract(tmpl_local[.x], "-.*"))
    })

    # 2nd previous block
    # fallback in case the previous block name does not exist anymore in the
    # template
    tmpl_blocks_names_fallback <- purrr::map_chr(custom_blocks_start, ~ {
      # find the line number of the respective block
      row_inds_prev_temp_block <- tail(purrr::keep(
        # row IDs of all blocks starting with "- name" but not followed by
        # [Custom ] (regex: negative lookahead)
        stringr::str_which(tmpl_local, "- name: (?!\"\\[Custom)"),
        function(y) y < .x
      ), n = 2)[1]
      # get the "name" of the previous block
      purrr::map_chr(row_inds_prev_temp_block, ~
      stringr::str_extract(tmpl_local[.x], "-.*"))
    })

    # - iterate along the "previous blocks" of the latest template and insert
    # the custom user blocks
    # - this needs to happen iterative because after the first block insertion
    # the row IDs of the subsequent blocks change
    # - Also: Execute in reverse order so that final order is ordered correctly
    for (i in rev(seq_along(tmpl_blocks_names))) {

      # - test if the new block exists in the latest template.
      # - if not, take the 2nd previous block and try if that one exists
      # - if that also does not exist, throw error -> manual update needed
      in_tmpl_latest <- purrr::map_lgl(tmpl_blocks_names[i], function(index) {
        any(stringr::str_detect(tmpl_latest, stringr::fixed(index)))
      })
      if (!in_tmpl_latest) {
        tmpl_blocks_names[i] <- tmpl_blocks_names_fallback[i]
      }
      # 2nd try
      in_tmpl_latest <- purrr::map_lgl(tmpl_blocks_names[i], function(index) {
        any(stringr::str_detect(tmpl_latest, stringr::fixed(index)))
      })
      if (!in_tmpl_latest) {
        cli::cli_par()
        cli::cli_end()
        cli::cli_alert_danger("Not enough unique anchor points between your
        local {.pkg tic} template and the newest upstream version could be
        found.
        Please update manually and try again next time.
        If this error persists, your local {.pkg tic} template is too different
        compared to the upstream template {.pkg tic} to support automatic
        updating.", wrap = TRUE)
        stopc("Not enough valid anchors points found between local and upstream template.") # nolint
      }


      # get the row IDs of the "previous blocks" in the latest template
      tmpl_latest_index <- purrr::map_int(
        tmpl_blocks_names[i],
        function(index) {
          stringr::str_which(tmpl_latest, stringr::fixed(index))
        }
      )

      # get the row where the "previous block" ends; after which the custom
      # block can be inserted
      tmpl_latest_insert_index <- purrr::map_int(
        tmpl_latest_index,
        function(insert_index) {
          purrr::keep(
            stringr::str_which(tmpl_latest, "^\\s*$"),
            function(x) x > insert_index
          )[1]
        }
      )

      tmpl_latest <- append(tmpl_latest, custom_blocks_list[[i]],
        after = tmpl_latest_insert_index
      )
    }
  }

  # update header -------------------------------------------------------

  custom_header <- stringr::str_which(
    tmpl_local,
    "#.\\[Custom header"
  )
  if (length(custom_header) > 0) {
    cli::cli_alert_info("Found a custom header entry. Will use it
      instead of the header in the {.pkg tic} upstream template.",
      wrap = TRUE
    )
    # find 'jobs:' tags
    custom_header_local <- stringr::str_which(
      tmpl_local,
      "env:"
    )
    custom_header_latest <- stringr::str_which(
      tmpl_latest,
      "env:"
    )

    # get latest revision date
    rev_date_latest <- as.Date(gsub(
      ".*(\\d{4}-\\d{2}-\\d{2}).*", "\\1",
      tmpl_latest[2]
    ), quiet = TRUE)

    # extract the local header
    header_local <- tmpl_local[1:custom_header_local]

    # replace the latest header with the local header
    tmpl_latest <- tmpl_latest[-(1:custom_header_latest)]
    tmpl_latest <- append(tmpl_latest, header_local, after = 0)

    # update latest revision date
    tmpl_latest[2] <- sprintf("## revision date: %s", rev_date_latest)
  }

  return(tmpl_latest)
}

update_circle_yml <- function(tmpl_local, tmpl_latest) {

  # update env vars ------------------------------------------------------------
  # this is very hacky...

  # find the line IDs of all custom env vars
  # env vars need to be prefixed with a comment including [Custom]
  custom_env_vars <- stringr::str_which(tmpl_local, "#.\\[Custom env")

  if (length(custom_env_vars) > 0) {
    cli::cli_alert_info("Found {.val {length(custom_env_vars)}} custom env
      variable{?s}.", wrap = TRUE)

    for (release in c(
      "# r-release-env", "# r-devel-env",
      "# r-deploy-env"
    )) {
      env_var_index_latest <- stringr::str_which(tmpl_latest, release) + 1

      # find the end of the block
      block_end <- purrr::keep(
        # find all blank lines so we know when blocks end and subtract one from
        # the ID
        stringr::str_which(tmpl_latest, "^\\s*$"), ~
        .x > env_var_index_latest
      )[1] - 1

      custom_env_var_list <- purrr::map(custom_env_vars, ~ {
        tmpl_local[.x:(.x + 1)]
      })

      # query which old env vars belong to the current environment iteration
      env_var_index_local <- stringr::str_which(tmpl_local, release) + 1
      block_end_local <- purrr::keep(
        # find all blank lines so we know when blocks end and subtract one from
        # the ID
        stringr::str_which(tmpl_local, "^\\s*$"), ~
        .x > env_var_index_local
      )[1] - 1

      # take only env vars that fall into the range
      sub_custom_env_var_list <- custom_env_var_list[(custom_env_vars >
        env_var_index_local) & (custom_env_vars < block_end_local)]

      if (length(sub_custom_env_var_list) > 0) {
        for (i in sub_custom_env_var_list) {
          tmpl_latest <- append(tmpl_latest, i, env_var_index_latest)
        }
      }
    }

    # see update-yaml-helpers.R
    tmpl_latest <- account_for_dup_env_vars(
      custom_env_var_list,
      env_var_index_latest,
      tmpl_latest
    )
  }

  # update user blocks ---------------------------------------------------------

  # find the line IDs of all custom user blocks
  custom_blocks_start <- stringr::str_which(
    tmpl_local,
    'name: "\\[Custom block'
  ) - 1

  if (length(custom_blocks_start > 0)) {
    cli::cli_alert_info("Found {.val {length(custom_blocks_start)}} custom user
                        block{?s}.", wrap = TRUE)

    # find all blank lines so we know when blocks end
    stringr::str_which(tmpl_local, "^\\s*$")

    # Create list storing all custom user blocks
    # User blocks need to start with "[Custom]"
    custom_blocks_list <- purrr::map(custom_blocks_start, ~ {
      # find the line number of the respective block
      block_end <- purrr::keep(
        # find all blank lines so we know when blocks end and subtract one from
        # the ID
        stringr::str_which(tmpl_local, "^\\s*$"),
        function(y) y > .x
      )[1] - 1
      # append an empty newline here for spacing between blocks when writing to
      # disk later
      append(tmpl_local[.x:block_end], "")
    })

    # find all block names of previous blocks to have an anchor for later when
    # inserting

    # List of blocks after which the custom user blocks appear
    tmpl_blocks_names <- purrr::map_chr(custom_blocks_start, ~ {
      # find the line number of the respective block
      row_inds_prev_temp_block <- tail(purrr::keep(
        # row IDs of all blocks starting with "- name"
        stringr::str_which(tmpl_local, "- run:"),
        function(y) y < .x
      ), n = 1) + 1
      # get the "name" of the previous block
      purrr::map_chr(row_inds_prev_temp_block, ~
      stringr::str_extract(tmpl_local[.x], "name:.*"))
    })

    # iterate along the "previous blocks" of the latest template and insert the
    # custom user blocks
    # this needs to happen iterative because after the first block insertion the
    # row IDs of the subsequent blocks change
    for (i in seq_along(tmpl_blocks_names)) {

      # get the row IDs of the "previous blocks" in the latest template
      tmpl_latest_index <- purrr::map_int(
        tmpl_blocks_names[i],
        function(index) {
          stringr::str_which(tmpl_latest, stringr::fixed(index))
        }
      )

      # get the row where the "previous block" ends; after which the custom
      # block can be inserted
      tmpl_latest_insert_index <- purrr::map_int(
        tmpl_latest_index,
        function(insert_index) {
          purrr::keep(
            stringr::str_which(tmpl_latest, "^\\s*$"),
            function(x) x > insert_index
          )[1]
        }
      )

      tmpl_latest <- append(tmpl_latest, custom_blocks_list[[i]],
        after = tmpl_latest_insert_index
      )
    }
  }
  return(tmpl_latest)
}

#' Update tic Templates
#' @description
#' Adds a GitHub Actions workflow (`update-tic.yml`) to check for tic template
#' updates once a day.
#'
#' Internally, [update_yml()] is called. A Pull Request will be opened if
#' a newer upstream version of the local tic template is found.
#'
#' This workflow relies on a GITHUB_PAT with "workflow" scopes if GitHub Actions
#' templates should be updated.
#' Generate a GITHUB PAT and add it as a secret to your repo with
#' [gha_add_secret()].
#'
#' @examples
#' \dontrun{
#' use_update_tic()
#' }
#' @export
use_update_tic <- function() {
  tmpl <- readLines(system.file("templates/update-tic.yml", package = "tic"))
  writeLines(tmpl, con = ".github/workflows/update-tic.yml")

  cli::cli_alert("Added new file:")

  data <- data.frame(
    stringsAsFactors = FALSE,
    package = c(
      basename(getwd()), ".github", "workflows", "update-tic.yml"
    ),
    dependencies = I(list(
      ".github", "workflows", "update-tic.yml", character(0)
    ))
  )
  print(tree(data, root = basename(getwd())))

  cli::cli_alert_info("Note that you need to add a secret with 'workflow' scopes
    named {.var TIC_UPDATE} to your repo to make this automation work.
    You can use {.code tic::gha_add_secret(<secret>, 'TIC_UPDATE')} for this.",
    wrap = TRUE
  )
}
