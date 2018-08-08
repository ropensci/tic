context("test-integration-git.R")

test_that("integration test: git", {
  bare_repo_path <- tempfile("ticrepo")
  dir.create(bare_repo_path)
  git2r::init(bare_repo_path, bare = TRUE)

  package_path <- tempfile("ticpkg", fileext = "pkg")
  git2r::clone(bare_repo_path, package_path)

  cat("\n")
  expect_true(usethis::create_package(package_path, fields = list(), rstudio = FALSE, open = FALSE))
  withr::with_dir(
    package_path,
    {
      writeLines(
        c(
          'get_stage("deploy") %>%',
          '  add_code_step(writeLines(as.character(Sys.time()), "time.txt")) %>%',
          '  add_step(step_push_deploy())'
        ),
        "tic.R"
      )
      git2r::config(user.name = "tic", user.email = "tic@pkg.test")
      git2r::add(path = ".")
      git2r::commit(message = "Initial commit")
      git2r::push(refspec = "refs/heads/master")
    }
  )

  withr::with_dir(
    package_path,
    {
      callr::r(
        function() {
          tic::tic()
        },
        show = TRUE
      )
    }
  )

  last_bare_commit <- git2r::last_commit(bare_repo_path)
  expect_match(last_bare_commit$message, "Deploy from local build")
})
