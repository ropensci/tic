context("test-integration-early-failure.R")

test_that("integration test: early failure", {
  package_path <- tempfile("ticpkg", fileext = "pkg")

  cat("\n")
  dir.create(package_path)

  tic_r <- paste0(
    'get_stage("script") %>%\n',
    '  add_code_step(stop("oops")) %>%\n',
    '  add_code_step(writeLines(character(), "out.txt"))'
  )

  withr::with_dir(
    package_path, {
      writeLines(tic_r, "tic.R")
      writeLines("^tic\\.R$", ".Rbuildignore")
      expect_error(
        callr::r(
          function() {
            tic::run_all_stages()
          },
          show = TRUE,
          env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
        ),
        "A step failed in stage"
      )
      expect_false(file.exists("out.txt"))
    }
  )
})
