test_that("ci_can_push() never fails", {
  expect_type(ci_can_push(), "logical")
  expect_error(ci_can_push(), NA)
  expect_error(
    withr::with_envvar(c(id_rsa = NA), ci_can_push("BOGUS_TIC_TEST_ENVVAR")),
    NA
  )
})
