library(dplyr)
library(readr)
library(googlesheets4)
library(here)
library(tidyr)
library(stringr)
library(tibble)
library(lubridate)
library(DatawRappr)

i_am("scripts/customer_service.R")

publish_to_dw <- TRUE

ss <- "1S1tGCbf9WAe4Bgczxmmk-oo0HLit3MsyQ-WoEP7aU2Q"

cs_raw <- read_sheet(
  ss,
  sheet = "Sheet1",
  col_types = c(
    "Date of Incident" = "c"
  )
)

cs_clean <- cs_raw %>% 
  janitor::clean_names() %>%
  mutate(
    
    ## Date Processing
    date_clean = date_of_incident %>%
      str_squish() %>%
      str_remove_all("\\s+") %>%
      str_extract("^\\d+/\\d+/?\\d*"),
    
    date = mdy(date_clean),
    
    guessed_year = coalesce(
      year(lag(date)),
      year(lead(date))
    ),
    
    date_try2 = if_else(
      is.na(date),
      paste0(date_clean, "/", guessed_year),
      NA_character_
    ),
    
    date = coalesce(
      date,
      mdy(date_try2)
    ),
    
    # Useful columns
    month = lubridate::floor_date(date, unit = "month")
  ) %>%
  filter(
    month >= floor_date(today(), unit = "month") %m-% months(12),
    month < floor_date(today(), unit = "month")
  ) %>%
  select(date_of_incident, date, date_clean, -date_try2, -guessed_year, everything())


cs_chrt_dta <- cs_clean %>%
  select(month, nature_of_report) %>%
  separate_rows(nature_of_report, sep = ",") %>%
  mutate(
    nature_of_report = stringr::str_squish(nature_of_report)
  ) %>%
  count(month, nature_of_report) %>%
  tidyr::pivot_wider(
    names_from = "month",
    values_from = "n"
  )


dw_chart_id <- "tDQ69"
if (publish_to_dw) {
  dw_data_to_chart(cs_chrt_dta, dw_chart_id, parse_dates = FALSE)
  dw_publish_chart(dw_chart_id, return_urls = FALSE) 
}


vrh_per_month <- read_csv(
  here("data/ridership/fy26_urban_ridership.csv")
) %>%
  group_by(month) %>%
  summarise(
    total_vrh = sum(total_vrh)
  ) %>%
  ungroup() %>%
  mutate(
    year = if_else(month %in% month.name[7:12], 2025L, 2026L),
    month_start = as.Date(
      paste("1", month, year),
      format = "%d %B %Y"
    )
  )

cs_per_month <- cs_clean %>%
  count(month, name = "cs_interactions")

cs_per_vh_per_month <- left_join(
  vrh_per_month,
  cs_per_month,
  by = c("month_start"="month")
) %>%
  mutate(
    interactions_per_1000_vrh = cs_interactions / total_vrh * 1000
  ) %>%
  select(month_start, cs_interactions, total_vrh , interactions_per_1000_vrh) %>%
  rename(month = month_start)


# Note: I write this out so that I can read it back in in Performance Metrics
write_csv(cs_per_vh_per_month, here("data/customer_service/customer_service_interactions.csv"))

