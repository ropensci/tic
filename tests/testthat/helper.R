# borrowed from https://github.com/r-lib/usethis/blob/main/tests/testthat/helper.R
proj <- new.env(parent = emptyenv())

proj_get_ <- function() proj$cur

create_local_package <- function(dir = tempfile(pattern = "testpkg"),
                                 env = parent.frame(),
                                 rstudio = FALSE) {
  create_local_thing(dir, env, rstudio, "package")
}

create_local_project <- function(dir = tempfile(pattern = "testproj"),
                                 env = parent.frame(),
                                 rstudio = FALSE) {
  create_local_thing(dir, env, rstudio, "project")
}

create_local_thing <- function(dir = tempfile(pattern = pattern),
                               env = parent.frame(),
                               rstudio = FALSE,
                               thing = c("package", "project")) {
  thing <- match.arg(thing)
  # if (dir.exists(dir)) {
  #   ui_stop("Target {ui_code('dir')} {ui_path(dir)} already exists.")
  # }

  old_project <- proj_get_() # this could be `NULL`, i.e. no active project
  old_wd <- getwd() # not necessarily same as `old_project`

  withr::defer(
    {
      # ui_done("Deleting temporary project: {ui_path(dir)}")
      unlink(dir)
    },
    envir = env
  )
  # ui_silence(
  switch(thing,
    package = usethis::create_package(dir, rstudio = rstudio, open = FALSE, check_name = FALSE),
    project = usethis::create_project(dir, rstudio = rstudio, open = FALSE)
  )
  # )

  withr::defer(usethis::proj_set(old_project, force = TRUE), envir = env)
  usethis::proj_set(dir)

  withr::defer(
    {
      # ui_done("Restoring original working directory: {ui_path(old_wd)}")
      setwd(old_wd)
    },
    envir = env
  )
  setwd(usethis::proj_get())

  invisible(usethis::proj_get())
}
