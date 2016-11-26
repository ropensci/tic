context("deploy")

Running <- R6Class(
  "Running",
  inherit = TicStep,

  public = list(
    initialize = function(running = TRUE) {
      private$running <- running
    },
    prepare = function() { private$prepare_calls <- private$prepare_calls + 1L },
    run = function() { private$run_calls <- private$run_calls + 1L },
    check = function() private$running,

    get_prepare_calls = function() private$prepare_calls,
    get_run_calls = function() private$run_calls
  ),

  private = list(
    running = NULL,
    prepare_calls = 0L,
    run_calls = 0L
  )
)

test_that("prepare tasks", {
  running <- Running$new()
  not_running <- Running$new(FALSE)
  stage <- local(Stage$new("test") %>% add_step(running) %>% add_step(not_running), create_dsl())

  expect_output(
    expect_message(stage$prepare_all(), "Skipping"),
    "private$running",
    fixed = TRUE)

  expect_equal(running$get_prepare_calls(), 1L)
  expect_equal(not_running$get_prepare_calls(), 0L)

  expect_equal(running$get_run_calls(), 0L)
  expect_equal(not_running$get_run_calls(), 0L)

})

test_that("run tasks", {
  running <- Running$new()
  not_running <- Running$new(FALSE)
  stage <- local(Stage$new("asdfgh") %>% add_step(running) %>% add_step(not_running), create_dsl())

  expect_output(
    expect_message(stage$run_all(), "Skipping asdfgh"),
    "private$running",
    fixed = TRUE)

  expect_equal(running$get_prepare_calls(), 0L)
  expect_equal(not_running$get_prepare_calls(), 0L)

  expect_equal(running$get_run_calls(), 1L)
  expect_equal(not_running$get_run_calls(), 0L)

})
