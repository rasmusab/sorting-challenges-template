# This script reads in the data from the Concito Excel file and inlines that into the 
# template HTML file for the climate impact sorting challenge. Also inlined is the 
# Sortable.js library. The idea is to create a single HTML file that can be shared and
# that doesn't have any external dependencies.

library(tidyverse)
library(readxl)

template_html <- read_file("template-climate-impact-sorting-challenge.html")
# Downloaded from here: https://denstoreklimadatabase.dk/files/media/document/Downloadversion%201.2_ENG.xlsx
concito_raw <- read_xlsx("Downloadversion 1.2_DK_0.xlsx", sheet = "All countries and comparisons")
# Downloaded from here: https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js
sortable_js <- read_file("Sortable.min.js")


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

concito <- concito_raw |> 
  select(description = Name, emission_factor = `DK version 1.2`) |> 
  mutate(
    description = str_remove_all(description, name_parts_to_remove_regexp),
    description = paste0("1 kg of ", description),
    emission_factor = round(emission_factor, 2)
  ) |>
  filter(emission_factor > 0) |> 
  na.omit()

candidate_cards_js <- paste0(
  "var candidateCards = [\n",
  paste0(
    '            { description: "', concito$description,
    '", emissionFactor: ', concito$emission_factor, ' }',
    collapse = ",\n"
  ),
  "\n        ];\n"
)

real_data_html <- str_replace(
  template_html,
  regex(r"{var candidateCards = \[.*?\];}", dotall = TRUE),
  candidate_cards_js
)

real_data_and_inline_sortable_html <- str_replace(
  real_data_html,
  fixed(r"{<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>}"),
  paste0("<script>\n", sortable_js, "\n</script>")
)

write_file(real_data_and_inline_sortable_html, "climate-impact-sorting-challenge.html")
