test_that("list_macros() returns a character", {
  expect_vector(list_macros(), ptype = character())
})
