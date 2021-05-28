setup_presentation <- function(cache_prefix) {
  knitr::opts_chunk$set(echo = FALSE, cache = TRUE, autodep = TRUE,
                        fig.align = "center",
                        cache.path = paste0("./cache/", cache_prefix, "/"),
                        fig.path = paste0("./cache/", cache_prefix, "/"))
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