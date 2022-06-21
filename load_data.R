library(dplyr)

species_data <- read.csv("https://raw.githubusercontent.com/weecology/EvergladesWadingBird/main/SiteandMethods/species_list.csv") %>%
  select(species, commonname, scientificname, target_species)

max_counts_all <- read.csv("https://raw.githubusercontent.com/weecology/EvergladesWadingBird/main/Indicators/max_count_all.csv")
max_counts_all <- max_counts_all %>%
  inner_join(species_data, by = 'species') %>%
  filter(target_species == 'yes') %>%
  select(year, commonname, count) %>%
  rename(species = commonname)

max_counts_region <- read.csv("https://raw.githubusercontent.com/weecology/EvergladesWadingBird/main/Indicators/max_count.csv")