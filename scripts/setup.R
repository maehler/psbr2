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
  source(here("scripts/ggplot_themes.R"))
}

base64_img <- function(filename) {
  ext <- stringr::str_extract(filename, "(png|gif|jpg|jpeg)$")
  if (is.na(ext)) {
    stop(paste0("unknown extension: ", filename))
  }
  paste0("data:image/", ext, ";base64,", base64enc::base64encode(filename))
}