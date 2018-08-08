context("test-integration-package.R")

test_that("integration test: package", {
  package_path <- tempfile("ticpkg", fileext = "pkg")

  cat("\n")
  expect_true(usethis::create_package(package_path, fields = list(License = "GPL-2"), rstudio = FALSE, open = FALSE))
  withr::with_dir(
    package_path,
    {
      writeLines("add_package_checks()", "tic.R")
      git2r::init()
      git2r::config(user.name = "tic", user.email = "tic@pkg.test")
      git2r::add(path = ".")
      git2r::commit(message = "Initial commit")
      callr::r(
        function() {
          tic::tic()
        },
        show = TRUE,
        env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
      )
    }
  )
})
