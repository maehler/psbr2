add_business_day <- function(start_date, d) {
  if (!is.integer(d) && !is.numeric(d) && !all(d == as.integer(d)))
    stop("d must be coercible to integer")
  if ((length(start_date) != length(d)) &&
      (length(start_date) != 1) &&
      length(d) != 1) {
    stop("start_date and d must have equal length, or length == 1")
  }

  start_date <- lubridate::as_date(start_date)
  wd <- lubridate::wday(start_date)
  saturdays <- wd == 7
  sundays <- wd == 1
  if (any(saturdays) || any(sundays))
    warning("weekend dates are coerced to the previous Friday before applying weekday shift")
  start_date <- (start_date - saturdays * 1)
  start_date <- (start_date - sundays * 2)
  wd <- wd - saturdays * 1 + sundays * 5
  start_date + lubridate::days(7 * (d%/%5) + d%%5 + 2 * (wd - 2 > 4 - d%%5))
}
