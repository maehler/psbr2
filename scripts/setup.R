setup_presentation <- function(cache_prefix) {
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
}

base64_img <- function(filename) {
  ext <- stringr::str_extract(filename, "(png|gif|jpg|jpeg)$")
  if (is.na(ext)) {
    stop(paste0("unknown extension: ", filename))
  }
  paste0("data:image/", ext, ";base64,", base64enc::base64encode(filename))
}

note_fa <- function(icon, scale = 2) {
  icons::icon_style(icons::fontawesome(icon), scale = scale)
}

print_df_5 <- function(x, ...) {
  print(x, n = 5, ...)
}
