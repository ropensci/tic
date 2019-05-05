context("test-integration-git-race-path-branch.R")

test_that("integration test: git race condition with path and branch arguments set", {

  # - Creates and initializes a bare repo
  # - Clones repo in second location
  # - Updates repo (creates a file `clone.txt`)
  # - Clones repo again in third location
  # - Updates repo (updates that file `clone.txt`)
  # - Deployment is run in all three clones,
  #   emulating a race condition on Travis
  #
  # Deployment consists of listing all `.txt` files (recursively)
  # and writing the results to `deploy/dir.txt` .
  # Deployment always updates the tip of the repo.

  base_path <- tempfile_slash("git-race-path-branch-")
  dir.create(base_path)
  tmp <- function(x) file.path(base_path, x)


  bare_repo_path <- tmp("bare_repo")
  dir.create(bare_repo_path)
  git2r::init(bare_repo_path, bare = TRUE)

  package_path <- tmp("package")
  git2r::clone(bare_repo_path, package_path)

  cat("\n")
  withr::with_dir(
    package_path, {
      writeLines(
        c(
          'get_stage("deploy") %>%',
          paste0('  add_step(step_setup_push_deploy(path = "deploy", branch = "deploy-branch", remote_url = "', bare_repo_path, '")) %>%'),
          '  add_code_step(writeLines(sort(dir(pattern = "^clone[.]txt$", recursive = TRUE)), "deploy/dir.txt")) %>%',
          '  add_step(step_do_push_deploy(path = "deploy"))'
        ),
        "tic.R"
      )
      git2r::config(user.name = "tic", user.email = "tic@pkg.test")
      dir.create("deploy")
      writeLines(character(), "deploy/.gitignore")
      git2r::add(path = ".")
      git2r::commit(message = "Initial commit")
      git2r::push(refspec = "refs/heads/master")
    }
  )

  package_path_2 <- tmp("package_2")
  git2r::clone(bare_repo_path, package_path_2)

  withr::with_dir(
    package_path_2, {
      writeLines(character(), "clone.txt")
      git2r::config(user.name = "tic-clone", user.email = "tic-clone@pkg.test")
      git2r::add(path = ".")
      git2r::commit(message = "Add clone.txt")
      git2r::push()
    }
  )

  package_path_3 <- tmp("package_3")
  git2r::clone(bare_repo_path, package_path_3)

  withr::with_dir(
    package_path_3, {
      writeLines("clone-contents", "clone.txt")
      git2r::config(user.name = "tic-clone-2", user.email = "tic-clone-2@pkg.test")
      git2r::add(path = ".")
      git2r::commit(message = "Edit clone.txt")
      git2r::push()
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
  expect_match(last_bare_commit$message, "Edit clone[.]txt")

  deploy_path <- tempfile("ticdeploy", fileext = "pkg")
  git2r::clone(bare_repo_path, deploy_path, branch = "deploy-branch")
  withr::with_dir(
    deploy_path,
    git2r::config(user.name = "tic-deploy", user.email = "tic-deploy@pkg.test")
  )

  withr::with_dir(
    deploy_path, {
      git2r::fetch(name = "origin")
      system2("git", "reset origin/deploy-branch --hard")
      expect_equal(length(git2r::commits()), 1)
      expect_false(file.exists("clone.txt"))
      expect_equal(readLines("dir.txt"), sort(dir(package_path, pattern = "^clone[.]txt$", recursive = TRUE)))
    }
  )

  withr::with_dir(
    package_path_2, {
      callr::r(
        function() {
          tic::run_all_stages()
        },
        show = TRUE,
        env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
      )
    }
  )

  withr::with_dir(
    deploy_path, {
      git2r::fetch(name = "origin")
      system2("git", "reset origin/deploy-branch --hard")
      expect_equal(length(git2r::commits()), 2)
      expect_false(file.exists("clone.txt"))
      expect_equal(readLines("dir.txt"), sort(dir(package_path_2, pattern = "^clone[.]txt$", recursive = TRUE)))
    }
  )

  withr::with_dir(
    package_path_3, {
      callr::r(
        function() {
          tic::run_all_stages()
        },
        show = TRUE,
        env = c(callr::rcmd_safe_env(), TIC_LOCAL = "true")
      )
    }
  )

  withr::with_dir(
    deploy_path, {
      git2r::fetch(name = "origin")
      system2("git", "reset origin/deploy-branch --hard")
      expect_equal(length(git2r::commits()), 2)
      expect_false(file.exists("clone.txt"))
      print(readLines("dir.txt"))
      expect_equal(readLines("dir.txt"), sort(dir(package_path_3, pattern = "^clone[.]txt$", recursive = TRUE)))
    }
  )
})
