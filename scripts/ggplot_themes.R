theme_reveal_night <- function() {
  txt <- element_text(colour = "white")
  ggplot2::theme(
    text = txt,
    axis.text = txt,
    axis.title = txt,
    axis.ticks = element_blank(),
    panel.background = element_blank(),
    plot.background = element_blank(),
    legend.background = element_blank(),
    legend.key = element_blank(),
    panel.grid.major = element_line(colour = rgb(1, 1, 1, alpha = 0.3), size = 0.2),
    panel.grid.minor = element_line(colour = rgb(1, 1, 1, alpha = 0.02))
  )
}