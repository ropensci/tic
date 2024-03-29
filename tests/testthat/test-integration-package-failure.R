test_that("integration test: package failure", {
  # since the move to pak this tests fails during CI but succeed locally
  skip("failing weirdly since pak transition")

  cli::cat_boxx("integration test: package failure")

  package_path <- tempfile("ticpkg", fileext = "pkg")

  cat("\n")
  usethis::create_package(
    package_path,
    fields = list(License = "GPL-2"), rstudio = FALSE, open = FALSE
  )
  withr::with_dir(
    package_path,
    { # nolint
      writeLines("do_package_checks()", "tic.R")
      writeLines("^tic\\.R$", ".Rbuildignore")
      dir.create("tests")
      writeLines('stop("Check failure!")', "tests/test.R")
      expect_error(
        callr::r(
          function() {
            tic::run_all_stages()
          },
          show = TRUE,
          env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
        ),
        'A step failed in stage "script"'
      )
    }
  )
})
