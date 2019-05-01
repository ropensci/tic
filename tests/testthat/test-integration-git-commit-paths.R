context("test-integration-git-commit-paths.R")

test_that("integration test: git", {

  # - Commit only a subset of changes that occur during deployment
  # - Check that only these changes are really committed

  bare_repo_path <- tempfile_slash("ticrepo")
  dir.create(bare_repo_path)
  git2r::init(bare_repo_path, bare = TRUE)

  package_path <- tempfile("ticpkg", fileext = "pkg")
  git2r::clone(bare_repo_path, package_path)

  cat("\n")
  withr::with_dir(
    package_path, {
      writeLines(
        c(
          'get_stage("deploy") %>%',
          '  add_code_step(writeLines(as.character(Sys.time()), "time.txt")) %>%',
          '  add_code_step(writeLines(as.character(Sys.time()), "deploy/time.txt")) %>%',
          paste0('  add_step(step_push_deploy(remote_url = "', bare_repo_path, '", commit_paths = "deploy"))')
        ),
        "tic.R"
      )
      dir.create("deploy")
      writeLines(character(), "deploy/.gitignore")
      git2r::config(user.name = "tic", user.email = "tic@pkg.test")
      git2r::add(path = ".")
      git2r::commit(message = "Initial commit")
      git2r::push(refspec = "refs/heads/master")
    }
  )

  withr::with_dir(
    package_path, {
      callr::r(
        function() {
          tic::run_all_stages()
        },
        show = TRUE,
        env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
      )
    }
  )

  last_bare_commit <- git2r::last_commit(bare_repo_path)
  expect_match(last_bare_commit$message, "Deploy from local build")

  package_path_2 <- tempfile("ticpkg", fileext = "pkg")
  git2r::clone(bare_repo_path, package_path_2)

  withr::with_dir(
    package_path_2, {
      expect_false(file.exists("time.txt"))
      expect_true(file.exists("deploy/time.txt"))
    }
  )
})
