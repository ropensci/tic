test_that("update_yml() preserves custom user blocks", {
  update_yml(
    system.file("testdata/test-update-yaml.yml", package = "tic"),
    paste0(tempdir(), "test-update-yaml-updated.yml")
  )

  updated <- readLines(paste0(tempdir(), "test-update-yaml-updated.yml"))
  solution <- readLines(system.file("testdata/test-update-yaml-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})

test_that("update_yml() preserves custom env vars", {
  update_yml(
    system.file("testdata/test-update-yaml-env-var.yml", package = "tic"),
    paste0(tempdir(), "test-update-yaml-env-var-updated.yml")
  )

  updated <-readLines(paste0(tempdir(), "test-update-yaml-env-var-updated.yml")) # nolint
  solution <- readLines(system.file("testdata/test-update-yaml-env-var-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})


test_that("update_yml() preserves custom env vars AND blocks", {
  update_yml(
    system.file("testdata/test-update-yaml-env-and-blocks.yml", package = "tic"),
    paste0(tempdir(), "test-update-yaml-env-and-blocks-updated.yml")
  )

  updated <- readLines(paste0(tempdir(), "test-update-yaml-env-and-blocks-updated.yml")) # nolint
  solution <- readLines(system.file("testdata/test-update-yaml-env-and-blocks-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})

test_that("only GHA templates are accepted", {
  yaml <- use_travis_yml(write = FALSE, quiet = TRUE)

  expect_error(
    update_yml(
      yaml,
      "inst/test-helpers/test-update-yaml-updated.yml"
    ),
    "No GitHub Actions YAML file found."
  )
})
