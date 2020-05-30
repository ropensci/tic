#' Add a CI Status Badge to README files
#'
#' @description
#'  Adds a CI status badge to `README.Rmd` or `README.md`. By default the label
#'  is `"tic"`.
#'
#'  A custom branch can be specified via argument `branch`.
#'
#' @param provider `character(1)`\cr
#'   The CI provider to generate a badge for. Only `ghactions` is currently
#'   supported
#' @param branch `character(1)`\cr
#'   Which branch should the badge represent?
#' @param label `character(1)`\cr
#'   Text to use for the badge.
#'
#' @examples
#' \dontrun{
#' use_tic_badge(provider = "ghactions")
#'
#' # use a different branch
#' use_tic_badge(provider = "ghactions", branch = "develop")
#' }
#' @export
use_tic_badge <- function(provider,
                          branch = "master",
                          label = "tic") {

  requireNamespace("usethis", quietly = TRUE)

  label_badge <- label
  # whitespaces do not render in README.md files
  label_badge <- gsub(" ", "%20", label_badge)

  github_home <- paste0("https://github.com/", ci_get_slug())
  url <- paste0(github_home, "/actions")
  img <- paste0(
    github_home,
    "/workflows/",
    label_badge,
    "/badge.svg",
    "?branch=",
    branch
  )

  catch <- tryCatch(
    # suppressing "Multiple github remotes found. Using origin."
    # the git remote cannot be set anyways
    suppressWarnings(usethis::use_badge(label, url, img)),
    error = function(cond) {
      if ("object 'tic' not found" %in% cond) {
        cli_alert_danger("{.fun use_tic_badge}: Could not find anchors in
          README.\nYou need to add `<!-- badges: start -->` and
          `<!-- badges: end -->` to README.md/README.Rmd denoting the start and
          end of the badges to make {.fun use_tic_badge} work.",
          wrap = TRUE
        )
      } else {
        # return error message if the error is different
        message(cond)
      }
      return(NA)
    }
  )
  return(invisible(catch))
}
