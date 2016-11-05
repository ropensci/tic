context("steps")

test_that("can restrict task to branches", {
  step_not_run <- list(step(task_hello_world, on_branch = "falsy"))
  expect_equal(parse_steps(step_not_run), setNames(list(), character()))
  step_not_run <- list(step(task_hello_world, on_branch = "/falsy/"))
  expect_equal(parse_steps(step_not_run), setNames(list(), character()))
})

test_that("will run base task if branches match", {
  step_run <- list(step(task_hello_world, on_branch = c("mock-ci-branch", "falsy")))
  expect_equal(parse_steps(step_run), list(HelloWorld = task_hello_world()))
  step_run <- list(step(task_hello_world, on_branch = c("falsy", "mock-ci-branch")))
  expect_equal(parse_steps(step_run), list(HelloWorld = task_hello_world()))
  step_run <- list(step(task_hello_world, on_branch = "/^mock-ci-branch$/"))
  expect_equal(parse_steps(step_run), list(HelloWorld = task_hello_world()))
})

test_that("can restrict task to env var", {
  withr::with_envvar(
    list(ENV_VAR = ""),
    {
      step_not_run <- list(step(task_hello_world, on_env = "ENV_VAR"))
      expect_equal(parse_steps(step_not_run), setNames(list(), character()))
    }
  )
})

test_that("will run base task if env var matches", {
  withr::with_envvar(
    list(ENV_VAR = "some_value"),
    {
      step_run <- list(step(task_hello_world, on_env = "ENV_VAR"))
      expect_equal(parse_steps(step_run), list(HelloWorld = task_hello_world()))
    }
  )
})
