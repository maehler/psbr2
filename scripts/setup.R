setup_presentation <- function(cache_prefix, filename = NA) {
  knitr::opts_chunk$set(fig.width = 6, fig.height = 4, fig.retina = 2,
                        message = FALSE, warning = FALSE, dpi = 72,
                        cache.path = paste0("./figures/", cache_prefix, "_"),
                        fig.path = paste0("./figures/", cache_prefix, "_"))
  suppressPackageStartupMessages({
    library(conflicted)
    library(tidyverse)
    library(htmltools)
    library(here)
  })
  conflict_prefer("filter", "dplyr")
  source(here("scripts/ggplot_themes.R"))
  set.seed(12345)

  if (!is.na(filename)) {
    div(
      a(
        icons::fontawesome("github"),
        href = str_c("https://github.com/maehler/psbr2/tree/main/lectures/",
                     filename)
      ),
      class = "footer"
    )
  }
}

base64_img <- function(filename) {
  ext <- stringr::str_extract(filename, "(png|gif|jpg|jpeg)$")
  if (is.na(ext)) {
    stop(paste0("unknown extension: ", filename))
  }
  paste0("data:image/", ext, ";base64,", base64enc::base64encode(filename))
}

note_fa <- function(icon, scale = 2) {
  final_icon <- switch (icon,
    "warning" = "exclamation-triangle",
    "tip" = "lightbulb"
  )
  if (is.null(final_icon)) {
    final_icon <- icon
  }
  icons::icon_style(icons::fontawesome(final_icon), scale = scale)
}

note <- function(msg, type = c("tip", "warning"), class = "yellow") {
  type <- match.arg(type)
  div(
    p(
      note_fa(type),
      msg
    ),
    class = str_c(c("note", class), collapse = " ")
  )
}

print_df_5 <- function(x, ...) {
  print(x, n = 5, ...)
}

article_tile <- function(headline, lead, date, source, source_url) {
  div(
    tags$time(date, datetime = date),
    h1(headline),
    p(lead, class = "lead"),
    p(a(source, href = source_url), class = "source"),
    class = "article"
  )
}

collect_articles <- function(articles, rotation = 0) {
  modify(articles, ~ {
    if (!is.character(.)) {
      .$attribs$style <- str_c("transform: rotate(", rotation * runif(1, -1, 1), "deg);")
    }
    .
  }) %>% do.call(div, .)
}