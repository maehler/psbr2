#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(fs)
  library(here)
  library(purrr)
  library(rmarkdown)
  library(stringr)
})

`%>%` <- dplyr::`%>%`

"Render site

Usage:
  render.R lecture [--dir DIR] [--outdir DIR] N [N ...]
  render.R site
  render.R (-h | --help)

Options:
  -d --dir DIR     directory containing Rmd files to render [default: lectures]
  -o --outdir DIR  output directory for rendered files [default: lectures]
  -h --help        show this help text and exit" -> doc

args <- docopt::docopt(doc)

if (args$site) {
  render_site()
} else if (args$lecture) {
  if (length(args$N) == 1 && args$N == "all") {
    fs::dir_ls(fs::path_rel(here(args$dir), here()), type = "file", glob = "*.Rmd") %>% 
      Filter(x = ., f = function(x) !str_detect(basename(x), "^_")) %>% 
      walk(~ {
        render(., knit_root_dir = here(args$dir))
      })
  } else {
    walk(args$N, ~ {
      rmd_filename <- fs::dir_ls(
        fs::path_rel(here(args$dir), here()), type = "file",
        glob = str_c(sprintf("*/%02d", as.integer(.)), "*.Rmd"))
      cat(rmd_filename, '\n')
      if (length(rmd_filename) == 0) {
        stop(str_c("no lecture ", ., " found"))
      } else if (length(rmd_filename) > 1) {
        stop(str_c("more than one file found for lecture ", .))
      }
      render(names(rmd_filename),
             knit_root_dir = here(args$dir))
    })
  }
}
