# Data visualisation with ggplot2

library(tidyverse)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy,
                 colour = class))

# Manual points
ggplot(mpg) + geom_point(aes(displ, hwy), shape = 8)

# Facets with free scales, hard to compare
ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_wrap(vars(class), scales = "free")

ggplot(mpg) +
  geom_point(aes(displ, hwy)) +
  facet_wrap(vars(class), scales = "free_y")

# Difference between smooth and line
ggplot(mpg) +
  geom_smooth(aes(displ, hwy))

ggplot(mpg) +
  geom_line(aes(displ, hwy))

# Bar chart positions
ggplot(mpg) +
  geom_bar(aes(class, fill = drv), position = "dodge")

ggplot(mpg) +
  geom_bar(aes(class, fill = drv), position = "fill")
  
# Jitter, not so clear
ggplot(data = mpg) +
  geom_point(mapping = aes(x = factor(cyl), y = hwy),
             position = position_jitter(height = 0))

# Jitter, more clear
ggplot(data = mpg) +
  geom_point(mapping = aes(x = factor(cyl), y = hwy, colour = factor(cyl)),
             position = position_jitter(height = 0, width = 0.2))

# Manual colours and shapes
ggplot(mpg) +
  geom_point(aes(displ, hwy, colour = drv, shape = drv)) +
  scale_colour_manual(name = "drive",
                      values = c("4" = "forestgreen",
                                 "f" = "orange",
                                 "r" = "steelblue")) +
  scale_shape_manual(values = c("4" = 3,
                                "f" = 8,
                                "r" = 2))
