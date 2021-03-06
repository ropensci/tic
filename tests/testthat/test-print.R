test_that("print stages", {
  skip_on_os("windows")
  dsl_init(quiet = TRUE)

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/empty.txt")
  )

  get_stage("install") %>%
    add_step(step_install_deps())

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/install.txt")
  )

  get_stage("script") %>%
    add_step(step_rcmdcheck())

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/install-script.txt")
  )

  expect_known_output(
    print(get_stage("deploy"), omit_if_empty = FALSE),
    testthat::test_path("out/deploy-empty.txt")
  )

  do_pkgdown()

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/pkgdown.txt")
  )

  dsl_init(quiet = TRUE)

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/empty.txt")
  )

  do_bookdown()

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/bookdown.txt")
  )

  get_stage("install") %>%
    # exact duplicate with no arguments (should only appear once)
    add_step(step_session_info()) %>%
    # step with different argument (should appear)
    add_step(step_install_deps(repos = "test")) %>%
    # exact duplicate including arguments ((should only appear once))
    add_step(step_install_deps(repos = repo_default()))

  expect_known_output(
    print(dsl_get()),
    testthat::test_path("out/no-duplicated-steps.txt")
  )
})
