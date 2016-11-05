context("parse")

test_that("parsing", {
  expect_equal(parse_task_code(NULL), setNames(list(), character()))
  expect_equal(parse_task_code(""), setNames(list(), character()))
  expect_equal(parse_task_code("1; 2; 3"),
               setNames(list(quote(1), quote(2), quote(3)), as.character(1:3)))
  expect_equal(parse_task_code(c("1; 2; 3", "")),
               setNames(list(quote(1), quote(2), quote(3)), as.character(1:3)))
  expect_equal(parse_task_code(c("1; 2", "", "3")),
               setNames(list(quote(1), quote(2), quote(3)), as.character(1:3)))
})
