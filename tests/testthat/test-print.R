test_that("print stages", {
  skip_on_appveyor()
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
})
