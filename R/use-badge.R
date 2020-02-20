#' Add a CI Status Badge to README
#'
#' @description
#'  Adds a CI status badge generated via \url{https://shields.io/} to
#'  `README.Rmd` or `README.md`. By default the label `"R CMD Check via {tic}"`
#'  will be used. By setting `type = "logo`, a logo of the respective CI
#'  provider will be used instead.
#'
#'  A custom label can be provided via argument `label`.
#'
#' @param provider `character(1)`\cr
#'   The CI provider to generate a badge for. Only `ghactions` is currently
#'   supported
#' @param logo `logical(1)`\cr
#'   Should a logo of the respective CI provider be used?
#' @param label `character(1)`\cr
#'   Text to use for the badge. To use no label, set `label = NULL`.
#'
#' @export
#' @examples
#' \dontrun{
#' use_tic_badge(provider = "ghactions")
#'
#' # no logo, only label
#' use_tic_badge(provider = "ghactions", logo = FALSE)
#'
#' # no label, only logo
#' use_tic_badge(provider = "ghactions", label = NULL)
#' }
use_tic_badge <- function(provider,
                          logo = TRUE,
                          label = "R CMD Check via {tic}") {

  requireNamespace("usethis", quietly = TRUE)

  if (provider == "ghactions") {
    if (logo) {
      logo <- "logo=github"
    } else {
      logo <- NULL
    }

    if (!is.null(label)) {
      label_badge <- paste0("label=", label)
    } else {
      label_badge <- NULL
    }

    # melt them if both are provided
    if (!is.null(label_badge) && is.character(logo)) {
      badge_style <- paste0(logo, "&", label_badge)
    } else {
      badge_style <- paste0(logo, label_badge)
    }

    github_home <- paste0("https://github.com/", ci_get_slug())
    url <- paste0(github_home, "/actions")
    img <- paste0(
      "https://img.shields.io/github/workflow/status/",
      ci_get_slug(), "/R%20CMD%20Check%20via%20%7Btic%7D?",
      badge_style,
      "&style=flat-square"
    )

    # in case label = NULL
    if (is.null(label)) {
      label <- "build status"
    }
  }
  usethis::use_badge(label, url, img)
}
