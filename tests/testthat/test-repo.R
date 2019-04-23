context("test-repo")

test_that("can determine available packages from repos", {
  expect_error(available_packages(repos = repo_default()), NA)
  expect_error(available_packages(repos = repo_cloud()), NA)
  expect_error(available_packages(repos = repo_cran()), NA)
  expect_error(available_packages(repos = repo_bioc()), NA)
})
