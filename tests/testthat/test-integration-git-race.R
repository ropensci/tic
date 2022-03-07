test_that("integration test: git race condition", {
  cli::cat_boxx("integration test: git race")

  # - Creates and initializes a bare repo
  # - Clones repo in second location
  # - Updates repo (creates a file `clone.txt`)
  # - Clones repo again in third location
  # - Updates repo (updates that file `clone.txt`)
  #
  # Deployment consists of listing all `.txt` files and writing the results
  # to `dir.txt` .
  # Deployment always updates the tip of the repo.

  base_path <- tempfile_slash("git-race-")
  dir.create(base_path)
  tmp <- function(x) file.path(base_path, x)


  bare_repo_path <- tmp("bare_repo")
  dir.create(bare_repo_path)
  git2r::init(bare_repo_path, bare = TRUE)

  package_path <- tmp("package")
  git2r::clone(bare_repo_path, package_path)

  tic_r <- c(
    'get_stage("deploy") %>%',
    # step_write_text_file() evaluates eagerly, won't work here
    "  add_code_step(writeLines(",
    '    sort(dir(pattern = "^clone[.]txt$")), "dir.txt"',
    "  )) %>%",
    paste0('  add_step(step_push_deploy(remote_url = "', bare_repo_path, '"))')
  )

  cat("\n")
  withr::with_dir(
    package_path,
    {
      writeLines(tic_r, "tic.R")
      writeLines("^tic\\.R$", ".Rbuildignore")
      git2r::config(user.name = "tic", user.email = "tic@pkg.test")
      git2r::add(path = ".")
      git2r::commit(message = "Initial commit")
      system("git push") # git2r::push() is only trouble
    }
  )

  package_path_2 <- tmp("package_2")
  git2r::clone(bare_repo_path, package_path_2)

  withr::with_dir(
    package_path_2,
    {
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
    package_path_3,
    {
      writeLines("clone-contents", "clone.txt")
      git2r::config(
        user.name = "tic-clone-2", user.email = "tic-clone-2@pkg.test"
      )
      git2r::add(path = ".")
      git2r::commit(message = "Edit clone.txt")
      git2r::push()
    }
  )

  withr::with_dir(
    package_path,
    {
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

  withr::with_dir(
    package_path_2,
    {
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
    package_path,
    {
      system("git pull")
      expect_true(file.exists("clone.txt"))
      expect_equal(readLines("dir.txt"), sort(dir(pattern = "^clone[.]txt$")))
    }
  )

  withr::with_dir(
    package_path_3,
    {
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
    package_path,
    {
      system("git pull")
      expect_true(file.exists("clone.txt"))
      expect_identical(readLines("clone.txt"), "clone-contents")
      expect_equal(readLines("dir.txt"), sort(dir(pattern = "^clone[.]txt$")))
    }
  )
})
