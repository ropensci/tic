context("test-utils.R")

test_that("deps", {
  expect_equal(get_deps_from_code(quote({})), character())
  expect_equal(get_deps_from_code(quote(pkg::fun)), "pkg")
  expect_equal(get_deps_from_code(quote(pkg::fun("test"))), "pkg")
  expect_equal(
    get_deps_from_code(
      quote({
        pkg1::fun1("test1")
        pkg2::fun2("test2")
        if (TRUE) {
          pkg3::fun2("test3")
        }
      })
    ),
    paste0("pkg", 1:3)
  )
})
