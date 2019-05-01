context("test-integration-git.R")

test_that("integration test: git", {
  base_path <- tempfile_slash("git-")
  dir.create(base_path)
  tmp <- function(x) file.path(base_path, x)


  bare_repo_path <- tmp("bare_repo")
  dir.create(bare_repo_path)
  git2r::init(bare_repo_path, bare = TRUE)

  package_path <- tmp("package")
  git2r::clone(bare_repo_path, package_path)

  cat("\n")
  usethis::create_package(package_path, fields = list(), rstudio = FALSE, open = FALSE)
  withr::with_dir(
    package_path, {
      writeLines(
        c(
          'get_stage("deploy") %>%',
          '  add_code_step(writeLines(as.character(Sys.time()), "time.txt")) %>%',
          paste0('  add_step(step_push_deploy(remote_url = "', bare_repo_path, '"))')
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
})
