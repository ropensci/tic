context("test-repo")

test_that("can determine available packages from repos", {
  skip_if(getRversion() < "3.3")

  expect_error(available.packages(repos = repo_default()), NA)
  expect_error(available.packages(repos = repo_cloud()), NA)
  expect_error(available.packages(repos = repo_cran()), NA)
  expect_error(available.packages(repos = repo_bioc()), NA)
})
