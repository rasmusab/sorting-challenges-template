library(jsonlite)
library(tidyverse)
library(glue)
library(readxl)

GameTitle <- "Calories Sorting Challenge"
AuthorName <- "Rasmus Bååth"
GameDescription <- "Place the cards in order of increasing calorie content. How many can you get right before you make a mistake?"
Instructions <- GameDescription
LeftGuidanceText <- "←🥕Fewer calories"
RightGuidanceText <- "More calories🍔→"
InfoText <- r"{
  <p><b>Where is this data from?</b><br>
    The calorie information is sourced from <a href="https://catalog.data.gov/dataset/supertracker-source-code-and-foods-database">The SuperTracker foods database</a>.
  </p>
  
  <p><b>Who made this?</b><br>
    I, Rasmus Bååth, created this in 2024, feel free to check out my website: <a href="https://www.sumsar.net">https://sumsar.net</a>. 
  </p>
}"

# Now munging the data in the The SuperTracker foods database Excel file and 
# putting it in the format the template HTML file expects

# Downloaded from here: https://catalog.data.gov/dataset/supertracker-source-code-and-foods-database
nutrients <- read_xlsx("sorting-challenges/calories-sorting-challenge/supertrackerfooddatabase.xlsx", sheet = "Nutrients")

candidate_cards <- nutrients |> 
  select(description = foodname, kcal_per_100g = `_208 Energy (kcal)`) |> 
  filter(kcal_per_100g > 0) |>
  na.omit() |>
  mutate(
    description = glue("100 g of {description}"),
    value = round(kcal_per_100g),
    display = glue("{value} kcal")
  ) |> 
  filter(str_length(description) < 85) # Filter out overly long descriptions


# Convert the candidate_cards dataframe to JSON format for insertion into the template
CandidateCardsArray <- toJSON(candidate_cards, auto_unbox = TRUE)

# Finally, use the defined variables to fill in the template.
sorting_challenge_template <- read_file("template-sorting-challenge.html" ) 
completed_sorting_challenge <- glue(sorting_challenge_template, .open = "{{", .close = "}}")
write_file(completed_sorting_challenge, "sorting-challenges/calories-sorting-challenge/calories-sorting-challenge.html")
