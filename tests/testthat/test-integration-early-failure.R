context("test-integration-early-failure.R")

test_that("integration test: early failure", {
  package_path <- tempfile("ticpkg", fileext = "pkg")

  cat("\n")
  dir.create(package_path)
  withr::with_dir(
    package_path, {
      writeLines(
        'get_stage("script") %>% add_code_step(stop("oops")) %>% add_code_step(writeLines(character(), "out.txt"))',
        "tic.R"
      )
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
