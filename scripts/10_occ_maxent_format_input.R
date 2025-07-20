library(readr)
library(dplyr)

# Load your presence file
pres <- read_csv("data/table_inputs/vespa_occ_combined_10km.csv") %>%
  mutate(species = "vespa_velutina") %>%
  select(species, longitude, latitude)

# Save as MaxEnt-compatible CSV
write_csv(pres, "data/maxent_gui/occ/vespa_presence_10km.csv", na = "")
