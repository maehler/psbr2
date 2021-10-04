#' Environment management: removing variables from your environment.
#' 
x <- 5 + 2
rm(x)

#' List variables in your environment.
#'
ls()

#' Remove all variables in your environment.
#' 
rm(list = ls())

#' Functions. Arguments can be specified either by position, or by name.
#' 
seq()
seq(to = 10)
seq(0, 10, 2)
seq(0, 10, 2, length.out = 2)
seq(0, 10, length.out = 5)

#' Characters
#' 
x <- "hello \"world\""
x
cat(x)

#' Vector indexing and recycling.
#' 
x <- 10:15
x[c(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)]
x[c(TRUE, FALSE)]
x[c(TRUE, FALSE, FALSE)]
x[c(TRUE, FALSE, FALSE, TRUE, TRUE, FALSE, FALSE)]
x[x < 12]

#' Factor levels will be ordered lexicographically.
#'
x <- factor(c("one", "one", "two", "two", "three", "three"))
x
as.numeric(x)

#' Matrices.
#'
matrix(1:9, byrow = TRUE, nrow = 3)
matrix(1:9, byrow = TRUE, nrow = 2)
matrix(1:5, byrow = TRUE, ncol = 5, nrow = 3)
