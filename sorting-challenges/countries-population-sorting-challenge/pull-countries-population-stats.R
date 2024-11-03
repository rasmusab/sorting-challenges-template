library(tidyverse)
library(WDI) 

country_stats_by_year = WDI(
  indicator = c("SP.POP.TOTL"), 
  extra = TRUE, 
  latest = 1
)

countries_population <- country_stats_by_year |> 
  drop_na(capital) |> # Heuristic for what's a proper country here
  arrange(country, year) |> 
  group_by(country) |>
  # Keep the latest indicator for each country
  summarize(across(everything(), \(x) last(na.omit(x)))) |>
  select(
    country_name = country,
    iso3c,
    population = SP.POP.TOTL
  ) 

write_csv(countries_population, "sorting-challenges/countries-population-sorting-challenge/countries-population.csv")
