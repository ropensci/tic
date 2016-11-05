context("parse")

test_that("parsing", {
  expect_equal(parse_steps(list()), setNames(list(), character()))
  expect_equal(parse_steps(list(step(task_hello_world))), list(HelloWorld = task_hello_world()))
})
