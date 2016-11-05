run_tic_ <- function(file_name = "tic.R") {
  env <- new.env(parent = asNamespace(packageName()))
  source(file_name, local = env)

  list(
    after_success = env$after_success,
    deploy = env$deploy
  )
}

run_tic <- memoise::memoise(run_tic_)
