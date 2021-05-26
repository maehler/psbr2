suppressPackageStartupMessages({
  library(fs)
  library(here)
  library(purrr)
  library(rmarkdown)
  library(stringr)
})

`%>%` <- dplyr::`%>%`

"usage: render.R [-h] DAY [DAY ...]

OPTIONS:

  -d --dir DIR     directory containing Rmd files to render [default: lectures]
  -o --outdir DIR  output directory for rendered files [default: docs/lectures]
  -h               show this help text and exit" -> doc

args <- docopt::docopt(doc)

if (length(args$DAY) == 1 && args$DAY == "all") {
  fs::dir_ls(here(args$dir), type = "file", glob = "*.Rmd") %>% 
    Filter(x = ., f = function(x) !str_detect(basename(x), "^_")) %>% 
    walk(~ {
      render(., output_dir = args$outdir)
    })
} else {
  walk(args$DAY, ~ {
    rmd_filename <- fs::dir_ls(
      here(args$dir), type = "file",
      glob = str_c(sprintf("*/%02d", as.integer(.)), "*.Rmd"))
    cat(rmd_filename, '\n')
    if (length(rmd_filename) == 0) {
      stop(str_c("no lecture found for day ", .))
    } else if (length(rmd_filename) > 1) {
      stop(str_c("more than one file found for day ", .))
    }
    render(names(rmd_filename), output_dir = args$outdir)
  })
}
