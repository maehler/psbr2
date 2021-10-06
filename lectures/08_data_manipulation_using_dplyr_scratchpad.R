#' # Data manipulation using dplyr
#' 
library(tidyverse)
library(nycflights13)

#' ## Missing an equals sign 
#' 
#' Often in R we get pretty bad error messages.
#' This is an exception.
#' 
filter(flights, dep_delay <= 0, origin = "JFK")

#' If we write it a bit differently, we don't get a super-informative error message.
#' 
#' ```{r, eval = FALSE}
#' filter(flights, dep_delay <= 0 & origin = "JFK")
#' ```
#' 
#' ```
#' ## Error: unexpected '=' in "filter(flights, dep_delay <= 0 & origin ="
#' ```

#' ## OR filtering
#' 
#' We can also filter using OR logic (`|`).
#' 
filter(flights, dest == "LAX" | dest == "ORD")

#' ## Mutate across
#'
#' Create a smaller dataset...
#' 
flights_small <- select(flights, matches("time"), dest, origin)

#' ... that we then add new variables to by dividing all variables whose names end with "time" by 60, so converting minutes to hours.
#' The names are set to the original column names, but with "_hour" appended.
mutate(flights_small, across(.cols = ends_with("time"),
                             .fns = ~ . / 60,
                             .names = "{.col}_hour"))

#' Here's an example where we apply two functions to the same variables.
#' The default names in this case are the names of the original variables and the names of the functions that are applied to them.
#'
mutate(flights_small, across(.cols = ends_with("time"),
                             .fns = list(second = ~ . * 60,
                                         hour = ~ . / 60)))

#' ## Group by
#' 
#' Group by can be used in order to apply a function to groups of observations in a data frame.
#' In this example, I create a group for each day in the data, and then summarise it by counting the number of flights for each day, and calculating the mean arrival delay.
#' 
by_day <- group_by(flights, year, month, day)
summarise(by_day, n = n(), mean_arr_delay = mean(arr_delay, na.rm = TRUE))


#' ## Mutate across again
#' 
#' Here is another example of mutate where we use the existing function `mean`.
#' We have to pass it the argument `na.rm = TRUE` in order to get something back from it.
#' This is the reason why the argument names that are specific to `across` start with a period.
#' We can then tell what arguments belong to `across`, and what arguments belong to the function(s) in `.fns`.
#' 
group_by(flights, year, month, day) %>% 
  mutate(across(.cols = ends_with("time"),
                .fns = mean,
                na.rm = TRUE))


#' ## Separate/unite
#' 
#' Here are a couple of examples how we can use separate and unite in order to clean up a messy dataset.
#' 
table5 %>% 
  unite("year", century, year, sep = "") %>% 
  mutate(year = as.numeric(year)) %>% 
  separate(rate, into = c("cases", "population"), sep = "/",
           convert = TRUE)

table5 %>% 
  unite("year", century, year, sep = "") %>% 
  mutate(year = as.numeric(year)) %>% 
  separate(rate, into = c("cases", "population"), sep = "/") %>% 
  mutate(across(c(cases, population), as.integer))

#' ## Joins
#' 
#' Here is an example where I join the `flights` data frame with the `weather` data frame in order to see if there is a correlation between the departure delay and any of the weather metrics.
#' 
#' First I create a subset of the `flights` data, just for the sake of convenience.
#' 
flights2 <- flights %>% 
  select(year:day, hour, dest, origin, dep_delay)

#' This is then joined with the weather data.
#' 
flights_weather <- left_join(flights2, weather, c("origin", "year", "month", "day", "hour"))

#' Neither wind speed nor visibility seem to be associated with the departure delay.
#' 
ggplot(flights_weather, aes(dep_delay, wind_speed)) +
  geom_point()

ggplot(flights_weather, aes(dep_delay, visib)) +
  geom_point()

#' I pull out some weather variables that I then correlate with the departure delay.
#' For the correlation, we need to specify how missing values should be handled, check `?cor` for details.
#' 
weather_var <- flights_weather %>% select(dewp, humid, wind_speed, precip, pressure)
cor(flights_weather$dep_delay, weather_var,
    use = "complete.obs")

#' From this, we can see that the metric `pressure` had the highest correlation with the departure delay, so we can go ahead and plot this relationship.
#' There is a lot of overplotting going on, so I set the `alpha` parameter to a smallish value to be able to see the relationship better.
#' A value of 1/20 means that if we have 20 points that overlap, then the colour should be pure black.
#' 
ggplot(flights_weather, aes(dep_delay, pressure)) +
  geom_point(alpha = 1/20) +
  scale_x_log10()

#' ## Questions related to exercises
#' 
#' ### 
#' 
flights %>% 
  arrange(desc(is.na(dep_time))) %>% 
  select(year:day, dep_time)

#' ### Mutating joins
#' 
#' **Compute the average delay by destination, then join on the `airports` data frame so you can show the spatial distribution of delays.**
#' 
#' First I group the flights by `dest` and calculate the average arrival delay using `summarise` and `mean`.
#' 
flights2 <- flights %>% 
  group_by(dest) %>% 
  summarise(average_delay = mean(arr_delay, na.rm = TRUE))

#' I then make an inner join of `airports` and the newly created `flights2` tibble, which then is plotted according to the instructions in the book.
#' The delay is represented by both the point colour and the point size.
#' 
airports %>%
  inner_join(flights2, c("faa" = "dest")) %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(aes(colour = average_delay, size = average_delay)) +
  coord_quickmap()

#' ### Filter rows with `filter()`
#' 
#' **Find all flights that flew to Houston (`IAH` or `HOU`)**
#' 
#' First we look at an example that does not work.
#'
flights %>% 
  filter(dest == c("IAH", "HOU")) %>% 

#' At first glance it might seem that this is working since no errors are reported, and we get a tibble back.
#' However, if we write the expression differently, we get a different result.
flights %>% 
  filter(dest == "IAH" | dest == "HOU") %>% 
  nrow()

#' The reason that the first example does not work is due to vector recycling.
#' When comparing two vectors, R will recycle the shorter of the two in order to make them the same length.
#' A comparison like this
#' 
c(1, 2, 3, 4) == 2

#' is equivalent to
#'
c(1, 2, 3, 4) == c(2, 2, 2, 2)

#' The following comparison
#' 
c(1, 2, 3, 4) == c(1, 3)

#' is the same as
#' 
c(1, 2, 3, 4) == c(1, 3, 1, 3)

#' Whenever the shorter vector can be perfectly recycled into the longer vector (i.e. the length of the shorter is a multiple of the longer), we don't get any warning messages.
#' If this is not the case, we would get a warning.
#' 
c(1, 2, 3, 4) == c(1, 2, 4)

#' If we go back to the filtering of `flights`, we don't get a warning since this dataset has an even number of rows, and thus the vector `c("IAH", "HOU")` can be perfectly recycled.
#' 

#' A more consise way of checking multiple values at once is by using the `%in%` operator.
#' For each value in the vector left of `%in%`, it will check if that value is present in the vector to the right of `%in%`.
#' 
flights %>% 
  filter(dest %in% c("IAH", "HOU")) %>% 
  nrow()