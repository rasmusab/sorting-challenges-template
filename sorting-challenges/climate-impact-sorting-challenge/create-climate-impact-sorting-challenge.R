library(jsonlite)
library(tidyverse)
library(glue)
library(readxl)

GameTitle <- "Climate Impact Sorting Challenge"
AuthorName <- "Rasmus Bååth"
GameDescription <- "Place the cards in order of increasing climate impact. How many can you get right before you make a mistake?"
Instructions <- GameDescription
LeftGuidanceText <- "←🌱Less impact"
RightGuidanceText <- "More impact🔥→"
InfoText <- r"{
  <p><b>Where is this data from?</b><br>
    The data is from <a href="https://denstoreklimadatabase.dk/en/background">The Big Climate Database v1.2</a>, specifically the Danish emission factors. 
    I chose the Danish emission factors as they were the most complete, as this database is of Danish origin, but these emission factors will be roughly applicable to other European countries as well.
  </p>
  
  <p><b>Any caveats?</b><br>
    Yes, lots. Notably, these emission factors are <i>averages</i>, and the specific climate impact of any type of food can vary significantly depending on how the food is produced. 
    Another thing to consider is that the emission factors are per kg of food. This does not take into account that different foods have different nutritional values. 
    For example, a kg of butter has a much higher climate impact than a kg of lettuce, but a kg of butter also has a much higher energy content than a kg of lettuce.
  </p>
  
  <p><b>Who made this?</b><br>
    This was put together by me, Rasmus Bååth, in 2024, mostly by shouting at the computer until it did what I wanted (a.k.a. AI-driven development). 
    If you want to know more about me, check out my website: <a href="https://www.sumsar.net">https://sumsar.net</a>.
  </p>
}"

# Now munging the data from the Concito Excel file and put it in the format the 
# template HTML file expects

# Downloaded from here: https://denstoreklimadatabase.dk/files/media/document/Downloadversion%201.2_ENG.xlsx
concito_raw <- read_xlsx("sorting-challenges/climate-impact-sorting-challenge/Downloadversion 1.2_DK_0.xlsx", sheet = "All countries and comparisons")

name_parts_to_remove_regexp <- paste0(", (", paste0(c(
  "origin unknown",
  "raw",
  "sugar added",
  "table use",
  "soft",
  "average values",
  "decorticated",
  "tomato and cheese"
), collapse = "|"), ")")

candidate_cards <- concito_raw |> 
  select(description = Name, emission_factor = `DK version 1.2`) |> 
  filter(emission_factor > 0) |>
  na.omit() |>
  mutate(
    description = str_remove_all(description, name_parts_to_remove_regexp),
    description = glue("1 kg of {description}"),
    value = round(emission_factor, 2),
    display = glue("{value} kg CO<sub>2</sub>e")
  ) 


# Convert the candidate_cards dataframe to JSON format for insertion into the template
CandidateCardsArray <- toJSON(candidate_cards, auto_unbox = TRUE)

# Finally, use the defined variables to fill in the template.
sorting_challenge_template <- read_file("template-sorting-challenge.html" ) 
completed_sorting_challenge <- glue(sorting_challenge_template, .open = "{{", .close = "}}")
write_file(completed_sorting_challenge, "sorting-challenges/climate-impact-sorting-challenge/climate-impact-sorting-challenge.html")
