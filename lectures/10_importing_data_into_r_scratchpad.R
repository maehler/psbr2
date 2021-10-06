#' # Importing data into R
#' 
library(tidyverse)

#' If we are having problems importing data into R, it might be an idea to consider all columns as character columns.
#' This way, we will be able to look at the data in R and potentially identify any issues.
#' 
read_csv(readr_example("challenge.csv"),
         col_types = cols(.default = col_character())) %>% 
  view()

#' Generally, the best approach is to explicitly state what the different columns in your dataset should be.
#' This way you can avoid nasty surprises.
#' 
x <- read_csv(readr_example("challenge.csv"),
         col_types = cols(x = col_date(),
                          y = col_number()))

#' ## Data frame row names
#'
#' Base R data frames can have row names, but this becomes problematic if we have actual variables as row names.
#' These should instead be part of the actual data.
#' There are functions in the tibble package (part of the tidyverse) that can help us with this.
#' 
#' Here is an example using the built-in dataset `mtcars`, which is similar to the `mpg` dataset that we've seen before, but the car model is represented as row names.
#' 
head(mtcars)
has_rownames(mtcars)

#' Let's put the row names into a column of their own, and convert the data frame to a tibble.
#' 
rownames_to_column(mtcars, "model") %>% 
  as_tibble()

#' ## Reading Lucija's data
#' 
#' Here's an example of how I would read the data that Lucija has for the course.
#' I start by reading the first sheet of the Excel file into R using readxl.
#' 
library(readxl)
sheet_names <- excel_sheets("/Users/maehler/Downloads/qua2-1 DR5 IAA treatment fluroscence intensity data.xlsx")
d <- read_excel("/Users/maehler/Downloads/qua2-1 DR5 IAA treatment fluroscence intensity data.xlsx",
                skip = 1, col_names = FALSE, sheet = sheet_names[1])

#' There are some columns that consist of only missing values.
#' Those I detect here by summarising every column in the tibble where I check if all values in the column are missing.
#' 
na_cols <- d %>%
  summarise(across(everything(), ~ all(is.na(.)))) %>% 
  unlist()

#' The `na_cols` object is then a logical vector where all `TRUE` values indicate columns that only contain missing values.
#' In order to select *all other* columns, we can index the tibble based on the negation of this vector.
#' 
d[, !na_cols]

#' We could achieve the same results in a more tidyverse manner:
#' 
d %>% select(which(!na_cols))
