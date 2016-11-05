context("tasks-base")

test_that("can't run base task", {
  task <- TravisTask$new()
  expect_null(task$prepare())
  expect_true(task$check())
  expect_error(task$run(), "override")
})

test_that("can run hello world task", {
  task <- task_hello_world()
  expect_null(task$prepare())
  expect_true(task$check())
  expect_output(task$run(), "world")
})

test_that("can restrict base task to branches", {
  task_not_run <- TravisTask$new(on_branch = "falsy")
  expect_false(task_not_run$check())
  task_not_run <- TravisTask$new(on_branch = "/falsy/")
  expect_false(task_not_run$check())
})

test_that("will run base task if branches match", {
  task_run <- TravisTask$new(on_branch = c("mock-ci-branch", "falsy"))
  expect_true(task_run$check())
  task_run <- TravisTask$new(on_branch = c("falsy", "mock-ci-branch"))
  expect_true(task_run$check())
  task_run <- TravisTask$new(on_branch = "/^mock-ci-branch$/")
  expect_true(task_run$check())
})
