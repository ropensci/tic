ci_ <- function() MockCI$new()

ci <- memoise::memoise(ci_)
