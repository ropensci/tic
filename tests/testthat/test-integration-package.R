context("test-integration-package.R")

test_that("integration test: package", {
  package_path <- tempfile("ticpkg", fileext = "pkg")

  cat("\n")
  usethis::create_package(package_path, fields = list(License = "GPL-2"), rstudio = FALSE, open = FALSE)
  withr::with_dir(
    package_path, {
      writeLines("do_package_checks()", "tic.R")
      callr::r(
        function() {
          tic::run_all_stages()
        },
        show = TRUE,
        env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
      )
    }
  )

  expect_true(TRUE)
})
