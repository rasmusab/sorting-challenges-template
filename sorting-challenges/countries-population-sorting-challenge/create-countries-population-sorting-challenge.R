library(jsonlite)
library(tidyverse)
library(glue)
library(scales)

GameTitle <- "Countries Population Sorting Challenge"
AuthorName <- "Rasmus Bååth"
GameDescription <- "Place the cards in order of increasing population. How many can you get right before you make a mistake?"
Instructions <- GameDescription
LeftGuidanceText <- "←👩 Smaller population"
RightGuidanceText <- "Larger population 👨‍👩‍👧‍👦→"
InfoText <- r"{
  <p><b>Where is this data from?</b><br>
    The population data is sourced from <a href="https://databank.worldbank.org/source/world-development-indicators">the World bank's World Development Indicators</a> in November 2024.
  </p>
  
  <p><b>Who made this?</b><br>
    This was created by me, Rasmus Bååth, in 2024. You can learn more about my work at my website: <a href="https://www.sumsar.net">https://sumsar.net</a>.
  </p>
}"

# Downloaded from here: https://databank.worldbank.org/source/world-development-indicators but using the WDI package.
populations <- read_csv("sorting-challenges/countries-population-sorting-challenge/countries-population.csv")

# Downloaded from here: https://github.com/tamirpomerantz/Countries-flag-emoji-csv/blob/master/countries.csv
country_flags <- read_csv("sorting-challenges/countries-population-sorting-challenge/country-flags.csv", col_names = c("flag", "iso3c"))

candidate_cards <- populations |> 
  inner_join(country_flags, by = c("iso3c")) |>
  na.omit() |>
  mutate(
    description = glue("{flag}<br>{country_name}"),
    value = population,
    display = glue("{label_comma()(population)} people")
  ) 


# Convert the candidate_cards dataframe to JSON format for insertion into the template
CandidateCardsArray <- toJSON(candidate_cards, auto_unbox = TRUE)

# Finally, use the defined variables to fill in the template.
sorting_challenge_template <- read_file("template-sorting-challenge.html" ) 
completed_sorting_challenge <- glue(sorting_challenge_template, .open = "{{", .close = "}}")
write_file(completed_sorting_challenge, "sorting-challenges/countries-population-sorting-challenge/countries-population-sorting-challenge.html")
