#' @title Update tic YAML Templates
#' @description Updates YAML templates to their
#'   latest versions. Currently only GitHub Actions and Circle CI templates are
#'   supported.
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
#'   paths of GitHub Actions, Travis CI and Circle CI will be searched and
#'   updated if they exist. Alternatively a full path to a single template can
#'   be passed.
#' @param template_out `[character]`\cr
#'   Where the updated template should be written to. This is mainly used for
#'   internal testing purposes and should not be set by the user.
#'   Can only be set
#'
#' @examples
#' \dontrun{
#' update_yml("main.yml")
#'
#' # custom named templates
#' update_yml("custom-name.yml")
#'
#' # full paths
#' update_yml("~/path/to/repo/.github/workflows/main.yml")
#' }
#' @seealso yaml_templates
#' @export
update_yml <- function(template_in = NULL,
                       template_out = NULL) {

  # by default all templates will be updated that can be found
  if (is.null(template_in)) {
    # check for existences of .travis.yml, circle-ci/config.yml and main.yml
    if (file.exists(usethis::proj_path(".github/workflows", "main.yml"))) {
      ghactions <- usethis::proj_path(".github/workflows", "main.yml")
    }
    if (file.exists(usethis::proj_path(".circleci/", "config.yml"))) {
      circle <- usethis::proj_path(".circleci", "config.yml")
    }
    if (file.exists(usethis::proj_path("travis.yml"))) {
      travis <- usethis::proj_path("travis.yml")
    }
    providers <- c(ghactions, circle, travis)
  } else {
    providers <- template_in
  }


  for (instance in providers) {

    # skip if one does not exist
    if (instance == FALSE) {
      next
    }

    instance <- readLines(instance)

    # some assertions
    if (!any(stringr::str_detect(instance, "(GitHub Actions)|(Circle CI)"))) {
      cli_alert_danger("No supported YAML file was found. If you are sure
      that you supplied one, make sure it contains `{.code GitHub Actions}
      {.code or Circle CI} in the first line as shown in the latest {.pkg tic}
      template versions.", wrap = TRUE)
      stop("No valid YAML file found.")
    }

    # by default overwrite the current template.
    if (is.null(template_out)) {
      template_out <- instance
    } else {
      if (is.null(template_in)) {
        cli_alert_danger("{.code template_in} must be set if
                         {.code template_out} is supplied.", wrap = TRUE)
        stopc("Please provide a template.")
      }
    }

    # read date of local template to compare against upstream template date
    rev_date_local <- as.Date(gsub(
      ".*(\\d{4}-\\d{2}-\\d{2}).*", "\\1",
      instance[2]
    ), quiet = TRUE)
    if (is.na(rev_date_local)) {
      cli::cli_alert_danger("It looks like your current {.pkg tic} template does
     not yet have a revision date. Please update the template manually one last
     time or add a revision date and the template type manually as the  first
     line of your template.", wrap = TRUE)
      stopc("No revision date found in current template.")
    }

    # find template type
    tmpl_type <- stringr::str_split(instance[1], "template: ",
      simplify = TRUE
    )[, 2]
    # get ci provider information
    ci_provider <- stringr::str_extract_all(instance[1],
      "(?<=tic ).+(?= template)",
      simplify = TRUE
    )[1, 1]
    tmpl_latest <- switch(ci_provider,
      "GitHub Actions" = use_ghactions_yml(tmpl_type,
        write = FALSE,
        quiet = TRUE
      ),
      "Circle CI" = use_circle_yml(tmpl_type, write = FALSE, quiet = TRUE),
      "Travis CI" = use_travis_yml(tmpl_type, write = FALSE, quiet = TRUE),
    )
    # get revision date from upstream template
    rev_date_latest <- as.Date(gsub(
      ".*(\\d{4}-\\d{2}-\\d{2}).*", "\\1",
      tmpl_latest[2]
    ), quiet = TRUE)

    if (!rev_date_latest > rev_date_local) {
      rlang::abort(sprintf(
        "You already have the latest version of the template (%s).",
        rev_date_latest
      ))
    } else {
      cli::cli_alert("Updating template from version '{rev_date_local} to
                   version '{rev_date_latest}'.", wrap = TRUE)
    }

    # call internal update function for each provider
    tmpl_latest <- switch(ci_provider,
      "GitHub Actions" = update_ghactions_yml(instance, tmpl_latest),
      "Circle CI"      = update_circle_yml(instance, tmpl_latest) # ,
      # "Travis CI"      = update_travis_yml(instance, tmpl_latest),
    )

    writeLines(tmpl_latest, template_out)
  }

  cli::cli_alert_info("Please carefully review the changes.
                      {.fun update_yml} is still in beta.", wrap = TRUE)
}

update_ghactions_yml <- function(tmpl_local, tmpl_latest) {
  # update env vars ------------------------------------------------------------

  # find the line IDs of all custom env vars
  # env vars need to be prefixed with a comment including [Custom]
  custom_env_vars <- stringr::str_which(tmpl_local, "#.\\[Custom")

  if (length(custom_env_vars) > 0) {
    cli::cli_alert_info("Found {length(custom_env_vars)} custom env var.")
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
  }

  # update user blocks ---------------------------------------------------------

  # find the line IDs of all custom user blocks
  custom_blocks_start <- stringr::str_which(tmpl_local, 'name: "\\[Custom')

  if (length(custom_blocks_start > 0)) {

    cli::cli_alert_info("Found {length(custom_blocks_start)} custom user
                        block.", wrap = TRUE)

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

update_circle_yml <- function(tmpl_local, tmpl_latest) {

  # update env vars ------------------------------------------------------------
  # this is very hacky...

  # find the line IDs of all custom env vars
  # env vars need to be prefixed with a comment including [Custom]
  custom_env_vars <- stringr::str_which(tmpl_local, "#.\\[Custom")

  if (length(custom_env_vars) > 0) {
    cli::cli_alert_info("Found {length(custom_env_vars)} custom env var.")

    for (release in c(
      "# r-release-env", "# r-oldrelease-env",
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
  }

  # update user blocks ---------------------------------------------------------

  # find the line IDs of all custom user blocks
  custom_blocks_start <- stringr::str_which(tmpl_local, 'name: "\\[Custom') - 1

  if (length(custom_blocks_start > 0)) {

    cli::cli_alert_info("Found {length(custom_blocks_start)} custom user
                        block.", wrap = TRUE)

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