# Code for making the third figure in the FiveThirtyEight article.
# Titled "Baby boomers are the biggest generation in Congress today".
# Must have already run "setup.R".

# Calculate the cumulative percentages of each generation in the Senate/House.
# I.e., the percentages for the Lost generation show the percentages of
# members in the Senate/House that are in the generations up to the Lost
# generation (Gilded + Progressive + Missionary + Lost).
cumulative_percentages <- data |>
  group_by(generation, congress) |>
  summarize(members = n(), start_year = start_year[[1]], .groups = "drop") |>
  arrange(congress, generation) |>
  group_by(congress) |>
  mutate(
    members_cum = cumsum(members),
    members_cum_low = c(0, members_cum[-length(members_cum)]),
    pct_cum = 100 * members_cum / members_cum[[length(members_cum)]],
    pct_cum_prev = 100 * members_cum_low / members_cum[[length(members_cum)]]
  ) |>
  ungroup()

ggplot(
  cumulative_percentages,
  aes(start_year, ymin = pct_cum_prev, ymax = pct_cum,
    group = generation, fill = generation)
) +

# The actual colored regions of the plot
geom_ribbon(color = "white") +

# Horizontal grid line lines to indicate the year
geom_hline(yintercept = seq(0, 100, by = 20), linewidth = 0.3, alpha = 0.1) +

# Aesthetic and labeling options
scale_color_manual(values = colors_ribbon_plot, aesthetics = "fill") +
labs(
  title = "Baby boomers are the biggest generation in Congress today",
  subtitle = "Share of members in Congress from each generation, 1919 to 2023",
  caption = "Birth years for the Greatest Generation to Generation Z are based on Pew Research Center definitions.\nFor earlier generations, definitions are based on Strauss and Howe (1991). They are: Gilded (1822-1842),\nProgressive (1843-1859), Missionary (1860-1882), Lost (1883-1900), Greatest (1901-1927),\nSilent (1928-1945), baby boomer (1946-1964), Generation X (1965-1980), millennial (1981-1996),\nGeneration Z (1997-2012)."
) +
scale_x_continuous(breaks = seq(1920, 2020, by = 10)) +
scale_y_continuous(
  breaks = seq(0, 100, by = 20),
  labels = c(as.character(seq(0, 80, by = 20)), "100%")
) +
theme_classic(14) +
theme(
  plot.title = element_text(vjust = 20),
  plot.subtitle = element_text(vjust = 20),
  plot.caption = element_text(hjust = 0),
  legend.position = c(.5, 1.1),
  legend.direction = "horizontal",
  legend.title = element_blank(),
  legend.background = element_blank(),
  axis.line = element_blank(),
  axis.title = element_blank(),
  axis.ticks = element_blank(),
  aspect.ratio = 1 / 2
)

# Save figure to file
ggsave("plots/figure2.png", width = 480 * 3, height = 400 * 3, units = "px", dpi = 60 * 3)
