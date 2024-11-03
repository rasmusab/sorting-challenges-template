# Load necessary libraries
library(jsonlite)
library(tidyverse)
library(glue)

# Define the placeholder variables to be inserted into the template
# You can see a varialbe is a placeholder, as it uses a weird UpperCamelCase name.
GameTitle <- "Calorie Content Sorting Challenge"
GameDescription <- "Place the foods in order of increasing calorie content per 100g."
AuthorName <- "Rasmus Bååth"
Instructions <- "
  Drag and drop the food items to arrange them in order of increasing calorie content per 100g. 
  See how many you can get right before making a mistake!
"
LeftGuidanceText <- "← Less calories"
RightGuidanceText <- "More calories →"
InfoText <- "<p>
  <b>About this game</b><br>This game helps you learn about the calorie content of different foods.
</p>"

# Create the candidates cards, here with made up with food items, 
# but generally here's where you would read in some data and munge it into 
# the target forma with the columns:
# description: The name of the card
# value: The numeric value of the card
# display: The string that will be revealed on the card
candidate_cards <- tribble(
  ~description,       ~value, ~display,
  "Apple",            52,     "52 kcal per 100g",
  "Banana",           96,     "96 kcal per 100g",
  "Broccoli",         34,     "34 kcal per 100g",
  "Cheddar Cheese",   403,    "403 kcal per 100g",
  "Chicken Breast",   165,    "165 kcal per 100g",
  "White Rice",       130,    "130 kcal per 100g",
  "Avocado",          160,    "160 kcal per 100g",
  "Salmon",           208,    "208 kcal per 100g",
  "Almonds",          579,    "579 kcal per 100g",
  "Dark Chocolate",   546,    "546 kcal per 100g"
)
# Convert the candidate_cards dataframe to JSON format for insertion into the template
CandidateCardsArray <- toJSON(candidate_cards, auto_unbox = TRUE)

# Finally, use the defined variabes to fill int he template.
sorting_challenge_template <- read_file("template-sorting-challenge.html" ) 
completed_sorting_challenge <- glue(sorting_challenge_template, .open = "{{", .close = "}}")
write_file(completed_sorting_challenge, "example-sorting-game.html")
