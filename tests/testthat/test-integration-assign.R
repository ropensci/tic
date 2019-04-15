context("test-integration-assign.R")

test_that("integration test: assign (#33)", {
  package_path <- tempfile("rcipkg", fileext = "pkg")

  cat("\n")
  dir.create(package_path)
  withr::with_dir(
    package_path,
    {
      writeLines(
        'script_stage <- get_stage("script")',
        "rci.R"
      )
      expect_error(
        callr::r(
          function() {
            rci::run_all_stages()
          },
          show = TRUE,
          env = c(callr::rcmd_safe_env(), RCI_LOCAL = "true")
        ),
        NA
      )
      expect_false(file.exists("out.txt"))
    }
  )
})
