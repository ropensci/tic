library(testthat)
library(tic)

withr::with_envvar(
  list("TIC_MOCK" = "true"),
  test_check("tic")
)
