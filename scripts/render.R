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
  render.R notes N
  render.R clean [-n]
  render.R (-h | --help)

Options:
  -d --dir DIR     directory containing Rmd files to render [default: lectures]
  -o --outdir DIR  output directory for rendered files [default: lectures]
  -n --dryrun      only list files that would be affected by clean
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
} else if (args$notes) {
  r_filename <- fs::dir_ls(
    fs::path_rel(here(args$dir), here()), type = "file",
    glob = str_c(sprintf("*/%02d", as.integer(args$N)), "*.R")
  )
  cat(r_filename, '\n')
  if (length(r_filename) == 0) {
    stop(str_c("no notes found for lecture ", args$N))
  } else if (length(r_filename) > 1) {
    stop(str_c("more than one note was found for lecture ", args$N))
  }
  render(names(r_filename),
         knit_root_dir = here(args$dir),
         output_format = output_format(
           knitr = knitr_options(
             opts_chunk = list(
               cache.path = str_c("./figures/notes_", args$N, "_"),
               fig.path = str_c("./figures/notes_", args$N, "_"),
               error = TRUE
             )
           ),
           pandoc = pandoc_options(
             to = "html",
             args = c("--metadata", "author=",
                      "--metadata", "date=")
           ),
           base_format = html_document(
             self_contained = FALSE,
             lib_dir = "libs"
           ),
         ))
} else if (args$clean) {
  clean_site(preview = args$dryrun)
}
