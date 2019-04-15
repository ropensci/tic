context("test-integration-package.R")

test_that("integration test: package", {
  package_path <- tempfile("rcipkg", fileext = "pkg")

  cat("\n")
  usethis::create_package(package_path, fields = list(License = "GPL-2"), rstudio = FALSE, open = FALSE)
  withr::with_dir(
    package_path,
    {
      writeLines("do_package_checks()", "rci.R")
      dir.create("tests")
      writeLines('stop("Check failure!")', "tests/test.R")
      expect_error(
        callr::r(
          function() {
            rci::run_all_stages()
          },
          show = TRUE,
          env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
        ),
        'A step failed in stage "script"'
      )
    }
  )
})
