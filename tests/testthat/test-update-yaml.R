# GitHub Actions ---------------------------------------------------------------

test_that("update_yml() preserves custom env vars AND blocks", {
  update_yml(
    system.file("testdata/ghactions-test-update-yaml-env-and-blocks.yml", package = "tic"), # nolint
    paste0(tempdir(), "test-update-yaml-env-and-blocks-updated.yml")
  )

  updated <- readLines(paste0(tempdir(), "test-update-yaml-env-and-blocks-updated.yml")) # nolint
  solution <- readLines(system.file("testdata/ghactions-test-update-yaml-env-and-blocks-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})

# Circle CI --------------------------------------------------------------------

test_that("update_yml() preserves custom env vars AND blocks", {
  update_yml(
    system.file("testdata/circle-test-update-yaml-env-and-blocks.yml", package = "tic"), # nolint
    paste0(tempdir(), "circle-test-update-yaml-env-and-blocks-updated.yml")
  )

  updated <- readLines(paste0(tempdir(), "circle-test-update-yaml-env-and-blocks-updated.yml")) # nolint
  solution <- readLines(system.file("testdata/circle-test-update-yaml-env-and-blocks-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})

# Travis CI --------------------------------------------------------------------

test_that("update_yml() preserves custom env vars AND blocks", {
  update_yml(
    system.file("testdata/travis-test-update-yaml-env-and-blocks.yml", package = "tic"), # nolint
    paste0(tempdir(), "travis-test-update-yaml-env-and-blocks-updated.yml")
  )

  updated <- readLines(paste0(tempdir(), "travis-test-update-yaml-env-and-blocks-updated.yml")) # nolint
  solution <- readLines(system.file("testdata/travis-test-update-yaml-env-and-blocks-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})

# Other ------------------------------------------------------------------------

test_that("only GHA templates are accepted", {
  expect_error(
    update_yml(
      system.file("testdata/error-invalid-yaml.yml", package = "tic"),
      "inst/testdata/circle-test-update-yaml-env-and-blocks.yml"
    ),
    "No valid YAML file found."
  )
})
