account_for_dup_env_vars <- function(custom_env_var_list,
                                     env_var_index_latest,
                                     tmpl_latest) {
  requireNamespace("stats", quietly = TRUE)

  # get all custom env vars
  env_vars_raw <- gsub(" ", "",
    unlist(
      lapply(custom_env_var_list, function(x) strsplit(x[2], ":")[[1]][1]),
      recursive = TRUE
    ),
    fixed = TRUE
  )

  # find dups
  env_dups <- lapply(env_vars_raw, function(x) {
    length(grep(
      sprintf("%s: ", x),
      tmpl_latest[env_var_index_latest:length(tmpl_latest)]
    ))
  })

  for (i in seq_along(env_dups)) {
    if (env_dups[[i]] > 1) {
      # find the latest instance of the duplicated env var and remove it with
      # its comment
      env_to_remove <- c(
        grep(env_vars_raw[i], tmpl_latest)[2] - 1,
        grep(env_vars_raw[i], tmpl_latest)[2]
      )
      tmpl_latest[env_to_remove] <- NA
      tmpl_latest <- stats::na.omit(tmpl_latest)
      cli::cli_alert_info("Found duplicated env var {.var {env_vars_raw[i]}}
          after updating to the latest template version.
          Removed the latest instance to avoid duplicates.
          This happens if a custom env var has the same name as an env var
          defined in the {.pkg tic} template.", wrap = TRUE)
    }
  }
  return(tmpl_latest)
}
