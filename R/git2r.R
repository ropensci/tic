git2r_attrib <- function(x, name) {
  if (utils::packageVersion("git2r") > "0.21.0") {
    x[[name]]
  } else {
    `@`(x, as.name(name))
  }
}

git2r_head <- function(x) {
  if (utils::packageVersion("git2r") > "0.21.0") {
    git2r::repository_head(x)
  } else {
    utils::head(x)
  }
}
