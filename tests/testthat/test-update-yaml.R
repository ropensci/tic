test_that("update_yml() preserves custom user blocks", {
  update_yml(
    "inst/test-helpers/test-update-yaml.yml",
    "inst/test-helpers/test-update-yaml-updated.yml"
  )

  updated <- readLines("inst/test-helpers/test-update-yaml-updated.yml")
  solution <- readLines("inst/test-helpers/test-update-yaml-solution.yml")
  expect_equal(updated, solution)
})

test_that("update_yml() preserves custom env vars", {
  update_yml(
    "inst/test-helpers/test-update-yaml-env-var.yml",
    "inst/test-helpers/test-update-yaml-env-var-updated.yml"
  )

  updated <- readLines("inst/test-helpers/test-update-yaml-env-var-updated.yml")
  solution <- readLines("inst/test-helpers/test-update-yaml-env-var-solution.yml") # nolint
  expect_equal(updated, solution)
})


test_that("update_yml() preserves custom env vars AND blocks", {
  update_yml(
    "inst/test-helpers/test-update-yaml-env-and-blocks.yml",
    "inst/test-helpers/test-update-yaml-env-and-blocks-updated.yml"
  )

  updated <- readLines("inst/test-helpers/test-update-yaml-env-and-blocks-updated.yml") # nolint
  solution <- readLines("inst/test-helpers/test-update-yaml-env-and-blocks-solution.yml") # nolint
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
