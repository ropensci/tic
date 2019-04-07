context("test-stages.R")

test_that("Only known stages can be accessed", {
  expect_s3_class(TicDSL$new()$get_stage("install"), "TicStage")
  expect_error(TicDSL$new()$get_stage("oops"))
})
