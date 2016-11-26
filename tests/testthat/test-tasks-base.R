context("tasks-base")

test_that("can't run base task", {
  task <- TicStep$new()
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
