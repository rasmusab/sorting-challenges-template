library(jsonlite)
library(tidyverse)
library(glue)

GameTitle <- "U.S. Presidential Sorting Challenge"
AuthorName <- "Rasmus Bååth"
GameDescription <- "Place the cards in order of when each U.S. president first took office. How many can you get right before you make a mistake?"
Instructions <- GameDescription
LeftGuidanceText <- "← 🔔 Earlier presidents"
RightGuidanceText <- "Later presidents 📺 →"
InfoText <- r"{
  <p><b>Who made this?</b><br>
    This was created by me, Rasmus Bååth, in 2024. For more of my projects, feel free to check out my website: <a href="https://www.sumsar.net">https://sumsar.net</a>.
  </p>

  <p><b>Where is this data from?</b><br>
    The data was sourced from <a href="https://github.com/awhstin/Dataset-List/blob/master/presidents.csv">this GitHub repository</a> in November 2024.
  </p>
}"

# Downloaded from here: https://github.com/awhstin/Dataset-List/blob/master/presidents.csv
presidents <- read_csv("sorting-challenges/presidents-sorting-challenge/presidents.csv")

candidate_cards <- presidents |> 
  mutate(first_year = as.numeric(str_sub(`Years In Office`, 1, 4))) |>
  na.omit() |>
  mutate(
    description = `President Name`,
    value = first_year,
    display = glue("{Number} president<br>in {first_year}")
  ) 


# Convert the candidate_cards dataframe to JSON format for insertion into the template
CandidateCardsArray <- toJSON(candidate_cards, auto_unbox = TRUE)

# Finally, use the defined variables to fill in the template.
sorting_challenge_template <- read_file("template-sorting-challenge.html" ) 
completed_sorting_challenge <- glue(sorting_challenge_template, .open = "{{", .close = "}}")
write_file(completed_sorting_challenge, "sorting-challenges/presidents-sorting-challenge/presidents-sorting-challenge.html")
