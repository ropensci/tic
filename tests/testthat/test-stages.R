context("test-stages.R")

test_that("Only known stages can be accessed", {
  expect_s3_class(DSL$new()$get_stage("install"), "TicStage")
  expect_error(DSL$new()$get_stage("oops"))
})
