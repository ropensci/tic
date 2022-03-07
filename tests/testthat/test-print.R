test_that("print stages", {
  skip_on_os("windows")
  dsl_init(quiet = TRUE)

  print(dsl_get())
  expect_snapshot_output(
    print(dsl_get()) # ,
    # testthat::test_path("out/empty.txt")
  )

  get_stage("install") %>%
    add_step(step_install_deps())

  expect_snapshot_output(
    print(dsl_get())
  )

  get_stage("script") %>%
    add_step(step_rcmdcheck())

  expect_snapshot_output(
    print(dsl_get())
  )

  expect_snapshot_output(
    print(get_stage("deploy"), omit_if_empty = FALSE)
  )

  do_pkgdown()

  expect_snapshot_output(
    print(dsl_get())
  )

  dsl_init(quiet = TRUE)

  expect_snapshot_output(
    print(dsl_get())
  )

  do_bookdown()

  expect_snapshot_output(
    print(dsl_get())
  )

  get_stage("install") %>%
    # exact duplicate with no arguments (should only appear once)
    add_step(step_session_info()) %>%
    # step with different argument (should appear)
    add_step(step_install_deps(repos = "test")) %>%
    # exact duplicate including arguments ((should only appear once))
    add_step(step_install_deps(repos = repo_default()))

  expect_snapshot_output(
    print(dsl_get())
  )
})
