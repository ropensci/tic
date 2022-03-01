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

test_that("update_yml() fails with descriptive error message if diffs between
          local and upstream template are too large", {
  expect_error(
    update_yml(
      system.file("testdata/ghactions-check-update-fail.yml", package = "tic"), # nolint
    ),
    "Not enough valid anchors points found between local and upstream template."
  )
})

# Circle CI --------------------------------------------------------------------

test_that("update_yml() preserves custom env vars AND blocks - Circle CI", {
  update_yml(
    system.file("testdata/circle-test-update-yaml-env-and-blocks.yml", package = "tic"), # nolint
    paste0(tempdir(), "circle-test-update-yaml-env-and-blocks-updated.yml")
  )

  updated <- readLines(paste0(tempdir(), "circle-test-update-yaml-env-and-blocks-updated.yml")) # nolint
  solution <- readLines(system.file("testdata/circle-test-update-yaml-env-and-blocks-solution.yml", package = "tic")) # nolint
  expect_equal(updated, solution)
})
