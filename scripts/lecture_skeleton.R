#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(conflicted)
  library(dplyr)
  library(fs)
  library(here)
  library(purrr)
  library(readr)
  library(stringr)
  library(yaml)
})

conflict_prefer("filter", "dplyr", quiet = TRUE)
source(here("scripts/date_functions.R"))

"Create lecture skeletons

Create skeletons for all lectures based on -schedule.yml.
All relative paths will be resolved in relation to the
RStudio project root directory.

Usage:
  lecture_skeleton.R [-f] [-t FILE] [-o DIR] [N ...]
  lecture_skeleton.R (-h | --help)

Options:
  -t --template FILE  template to use [default: lectures/_template.Rmd]
  -o --outdir DIR     output directory [default: lectures]
  -f --force          create a skeleton even if a file exists
  -h --help           show this help text and exit" -> doc

args <- docopt::docopt(doc)

if (!file_exists(here("_schedule.yml"))) {
  stop("_schedule.yml not found")
}

schedule_data <- read_yaml(here("_schedule.yml"))
topic_df <- tibble(
  topic = flatten_chr(map(schedule_data$schedule,
                          ~ map_chr(.$day, ~ .$topic))),
  course_day = flatten_int(map2(
    schedule_data$schedule, seq_along(schedule_data$schedule),
    ~ rep(.y, length(.x$day)))),
  date = add_business_day(schedule_data$start_date, course_day-1),
  topic_slug = str_to_lower(topic) %>%
    str_replace_all("[-: ]", "_") %>%
    str_replace_all("['\"]", "") %>%
    str_replace_all("_+", "_"),
  topic_filename = path(
    args$outdir,
    str_c(sprintf("%02d", seq_along(topic)),
          "_", topic_slug, ".Rmd")) %>%
    here(),
  lecture = flatten_lgl(map(schedule_data$schedule,
                            ~ map_lgl(.$day, ~ is.null(.$lecture) || .$lecture))),
)

# Only include topics that should have lectures associated with them
topic_df <- topic_df %>% filter(lecture)

if (length(args$N) > 0) {
  topic_df <- topic_df %>% slice(all_of(as.integer(args$N)))
}

any_exists <- FALSE

pwalk(topic_df, ~ {
  if (!args$force && file_exists(..5)) {
    any_exists <<- TRUE
    return()
  }
  template_lines <- read_lines(here(args$template))
  script_lines <- template_lines %>%
    str_replace("\\{\\{topic\\}\\}", ..1) %>%
    str_replace("\\{\\{date\\}\\}", format(..3, format = "%Y-%m-%d")) %>%
    str_replace("\\{\\{topic_slug\\}\\}", ..4)
  write_lines(script_lines, file = ..5)
  message(str_c("Created skeleton for \"", ..1, "\" -> ",
                fs::path(args$outdir, basename(..5))))
})

if (any_exists) {
  warning("Some of the files already exist, rerun with --force to overwrite")
}
