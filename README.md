[![DOI](https://zenodo.org/badge/370710075.svg)](https://zenodo.org/badge/latestdoi/370710075)

# Practical Skills for Biology Research II

This repository contains materials for the course Practical Skills for Biology Research II (PSBR II).

## Prerequisites

- R >= 4
- RStudio

Install packages:

```R
install.packages(c(
  "tidyverse",
  "markdown",
  "rmarkdown",
  "knitr",
  "here",
  "htmltools",
  "xaringan",
  "conflicted",
  "devtools",
  "docopt",
  "fs"
))
```

Install the icons package from Github:

```R
devtools::install_github("mitchelloharawild/icons")
```

Download/update fontawesome:

```R
icons::update_fontawesome()
```

## Schedule

The course schedule is defined in `_schedue.yaml`. This is the structure of the file:

```yaml
start_date: 2021-09-30
defaults:
  room: Lecture hall 1
schedule:
  - day
    - start_time: "09:00"
      end_time: "10:00"
      topic: Course introduction
      url: lectures/01_course_introduction.html
      room: Lecture hall 2
      details: |
        This is some information on what will be covered in the lecture.
    - start_time: "10:00"
      end_time: "12:00"
      topic: RStudio
      url: lectures/02_rstudio.html
      room: Lecture hall 2
      details: |
        Information about the second lecture on the first day.
  - day:
    - start_time: "9:00"
      end_time: "12:00"
      topic: ggplot2
      url: lectures/03_ggplot2.html
      details: |
        Information about the lecture on the second day of the course.
```

The start date will be the first day of the course, and dates will be assigned to days that follow, excluding weekends. If the start date is a Friday, the first day of the course will be this date, and the second day of the course will be the following Monday.

A day can have multiple lectures, as demonstrated for the first day in the example above.

A default lecture room can be set under `defaults` . If a schedule item is missing `room`, the default room will be used.

## Rendering

Rendering of individual lectures can be done either through RStudio with the "knit" button, or the script `scripts/render.R` can be used from the command line:

```bash
./scripts/render.R lecture 1
```

where the last number is the number of the lecture. All lectures can be also rendered in one go:

```bash
./scripts/render.R lecture all
```

The site collecting the lectures can be rendered as well:

```bash
./scripts/render.R site
```

This should be done whenever the schedule, or any other page on the site gets updated. The configuration of the site itself can be found in `_site.yaml`. See the [rmarkdown documentation for more information](https://bookdown.org/yihui/rmarkdown/rmarkdown-site.html).
