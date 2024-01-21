# Load the libraries, load the raw data, and
# perform transformations on the data for the
# plotting scripts figure1.R and figure2.R.
# Must run this before figure1.R or figure2.R.

# Tidyverse is used for data processing and plotting.
# Install it if it is not already installed.
if (!require("tidyverse")) {
  install("tidyverse")
}
library(tidyverse)

# Load the raw data
data <- read_csv(
  "data/data_aging_congress.csv",
  col_types = cols( # Specify the column types
    chamber = "c",  # character
    state_abbrev = "c", # character
    bioname = "c", # character
    bioguide_id = "c", # character
    generation = "c", # character
    congress = "d", # double precision numerical
    party_code = "d", # double precision numerical
    cmltv_cong = "d", # double precision numerical
    cmltv_chamber = "d", # double precision numerical
    age_days = "d", # double precision numerical
    age_years = "d", # double precision numerical
    start_date = "D", # date
    birthday = "D" # date
  )
)

# We use this formula to compute the start year
# because the 66th congress started in 1919 and
# each congress lasts for 2 years.
data$start_year <- 2 * (data$congress - 66) + 1919

# Order the chamber categories as Senate first then House
# since this is how the FiveThirtyEight article does it.
data$chamber <- factor(data$chamber, c("Senate", "House"))

# Order the generation names in the same order as in the
# FiveThirtyEight figure.
data$generation <- factor(
  str_to_upper(data$generation),
  c(
    "GILDED",
    "PROGRESSIVE",
    "MISSIONARY",
    "LOST",
    "GREATEST",
    "SILENT",
    "BOOMERS",
    "GEN X",
    "MILLENNIAL",
    "GEN Z"
  ),
  ordered = TRUE
)