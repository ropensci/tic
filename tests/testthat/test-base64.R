test_that("roundtrip serialization", {
  x <- runif(10)
  expect_identical(base64unserialize(base64serialize(x)), x)
})
