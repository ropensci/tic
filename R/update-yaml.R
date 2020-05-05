#' @title Update tic YAML Templates
#' @description Updates the YAML tmps (GitHub Actions, Travis, Circle) to their
#'   latest versions. (For GHA user changes are preserved)
#'
#' @param `[character]`\cr
#'   Path to local template which should be updated.
#' @param `[character]`\cr
#'   Where the updated template should be written to. This is mainly used for
#'   internal testing purposes and should not be set by the user.
#'
#' @export
update_yml <- function(template_in = "main.yml",
                       template_out = NULL) {

  # try to find a template in .github/workflows first with the supplied value of
  # template_in. If that fails try the full path. This somewhat complex heuristic
  # is needed to combine user convenience and allow supplying a full path (for internal testing)
  if (file.exists(paste0(
    usethis::proj_get(),
    sprintf("/.github/workflows/%s", template_in)
  ))) {
    template_in <- paste0(
      usethis::proj_get(),
      sprintf("/.github/workflows/%s", template_in)
    )
  } else if (file.exists(template_in)) {
    template_in <- template_in
  } else {
    stop("No template found at supplied path.")
  }

  # by default overwrite the current template.
  if (is.null(template_out)) {
    template_out <- template_in
  }

  # we cannot use {yaml} because the underlying libyaml library does not parse comments
  tmpl_local <- readLines(template_in)

  # read date of local template to compare against upstream template date
  rev_date_local <- lubridate::dmy(gsub(
    ".*(\\d{2}/\\d{2}/\\d{4}).*", "\\1",
    tmpl_local[2]
  ), quiet = TRUE)
  if (is.na(rev_date_local)) {
    cli::cli_alert_danger("It looks like your current {.pkg tic} template does not
     yet have a revision date. Please update the template manually one last time
     or add a revision date and the template type manually as the  first line
     of your template.", wrap = TRUE)
    stopc("No revision date found in current template.")
  }
  rev_date_latest <- lubridate::dmy("12/04/2020")

  if (!rev_date_latest > rev_date_local) {
    rlang::abort(sprintf(
      "You already have the latest version of the tmp (%s).",
      rev_date_latest
    ))
  } else {
    cli::cli_alert("Updating template from version '{rev_date_local} to
                   version '{rev_date_latest}'.", wrap = TRUE)
  }

  # find template type
  tmpl_type <- stringr::str_split(tmpl_local[1], "template: ",
    simplify = TRUE
  )[, 2]
  # read the newest template
  tmpl_latest <- use_ghactions_yml(tmpl_type, write = FALSE, quiet = TRUE)

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

    cli::cli_alert_info("Found {length(custom_blocks_start)} custom user block.")

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

    # row IDs of all blocks starting with "- name"
    tmpl_blocks_start <- stringr::str_which(tmpl_local, "- name")

    # List of blocks after which the custom user blocks appear
    tmpl_blocks_names <- purrr::map_chr(custom_blocks_start, ~ {
      # find the line number of the respective block
      row_inds_prev_temp_block <- tail(purrr::keep(
        stringr::str_which(tmpl_local, "- name"),
        function(y) y < .x
      ), n = 1)
      # get the "name" of the previous block
      purrr::map_chr(row_inds_prev_temp_block, ~
      stringr::str_extract(tmpl_local[.x], "-.*"))
    })

    # sequence along the "previous blocks" of the latest template and insert the
    # custom user blocks
    # this needs to happen iteratively because after the first block insertion the
    # row IDs of the subsequent blocks change
    for (i in seq_along(tmpl_blocks_names)) {

      # get the row IDs of the "previous blocks" in the latest template
      tmpl_latest_index <- purrr::map_int(tmpl_blocks_names[i], function(index) {
        stringr::str_which(tmpl_latest, stringr::fixed(index))
      })

      # get the row where the "previous block" ends; after which the custom block
      # can be inserted
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

  writeLines(tmpl_latest, template_out)
}
