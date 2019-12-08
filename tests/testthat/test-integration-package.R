context("test-integration-package.R")

test_that("integration test: package", {
  skip_on_appveyor()
  cli::cat_boxx("integration test: package")

  package_path <- tempfile("ticpkg", fileext = "pkg")

  cat("\n")
  usethis::create_package(
    package_path,
    fields = list(License = "GPL-2"), rstudio = FALSE, open = FALSE
  )
  withr::with_dir(
    package_path,
    {
      writeLines("do_package_checks()", "tic.R")
      writeLines("^tic\\.R$", ".Rbuildignore")
      callr::r(
        function() {
          tic::run_all_stages()
        },
        show = TRUE,
        env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
      )
    }
  )

  # This is an integration test, we're good if we have reached this point.
  expect_true(TRUE)
})
