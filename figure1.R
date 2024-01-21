# Code for plotting the first figure in the FiveThirtyEight
# article titled "The House and Senate are older than ever before".
# Must have already run "setup.R".


# Get the median ages of each of the chambers (House and Senate)
# for each congress.
median_ages <- data |>
    group_by(start_year, chamber) |>
  summarize(age = median(age_years), start_year = start_year[[1]], .groups = "drop")

# Colors that the FiveThirtyEight article uses for the Senate and House lines.
colors <- c(Senate = "#6141D9", House = "#2AAD53")

# This is for plotting the text labels that show the 2023-2025 congress median age.
last_congress_age <- median_ages |> filter(start_year == 2023)

ggplot(
  median_ages,
  aes(
    x = start_year,
    y = age,
    group = chamber,
    color = chamber
  )
) +

# Horizontal grid line lines to indicate the year
geom_hline(yintercept = c(65, 60, 55, 50, 45), linewidth = 0.5, alpha = 0.5) +

# The actual lines showing the ages of each Senate/House.
geom_step(linewidth = 1.5) +

# Text on right of plot showing the age of the 2023 Senate/House
geom_text(
  data = last_congress_age, aes(start_year, age, label = round(age, 1)),
  nudge_x = 4
) +

# The aesthetic/labeling options
scale_color_manual(values = colors) +
labs(
  title = "The House and Senate are older than ever before",
  subtitle = "Median age of the U.S. Senate and U.S. House by Congress, 1919 to 2023",
  caption = "Data is based on all members who served in either the Senate or House in each Congress, which is notated\nby the year in which it was seated. Any member who served in both chambers in the same Congress was\nassigned to the chamber in which they cast more votes."
) +
scale_x_continuous(breaks = seq(1920, 2020, by = 10)) +
theme_classic(14) +
theme(
  plot.title = element_text(vjust = 5),
  plot.subtitle = element_text(vjust = 5),
  plot.caption = element_text(hjust = 0),
  legend.position = c(.1, 1.0),
  legend.direction = "horizontal",
  legend.title = element_blank(),
  legend.background = element_blank(),
  axis.line = element_blank(),
  axis.title = element_blank(),
  axis.ticks = element_blank(),
  aspect.ratio = 1 / 2,
)

# Save plot to file
ggsave("plots/figure1.png", width = 480 * 3, height = 400 * 3, units = "px", dpi = 60 * 3)

colors_ribbon_plot <- c(
  "GILDED" = "#E9E9E9",
  "PROGRESSIVE" = "#FEE7E5",
  "MISSIONARY" = "#E98CCA",
  "LOST" = "#8B8887",
  "GREATEST" = "#86D09D",
  "SILENT" = "#FDE384",
  "BOOMERS" = "#FD867E",
  "GEN X" = "#A593E9",
  "MILLENNIAL" = "#92DCE0",
  "GEN Z" = "#D26E8C"
)
