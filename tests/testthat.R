library(testthat)
library(rci)

withr::with_envvar(
  list("RCI_MOCK" = "true"),
  test_check("rci")
)
