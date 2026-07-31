library(dplyr)
library(readr)
library(googlesheets4)
library(here)
library(tidyr)
library(stringr)
library(tibble)
library(lubridate)
library(DatawRappr)

i_am("scripts/dropped_runs.R")

publish_to_dw <- TRUE

## Add Next Fiscal Year here when ready
fiscal_year_sheets <- tribble(
  ~fiscal_year, ~ss,
  2026L, "1OxsU3-A1oFJ0Ay4nPu76VSkX3HT13S35A3BUT3XCF5k",
  2027L, "1E33s8hXAukY0Dl_ZlC6iKJmqlzO7sGBbEIvE3zNhu0A"
)

months <- c(month.name[7:12], month.name[1:6])

all_months <- tibble()

for (fy in fiscal_year_sheets$fiscal_year) {
  
  ss <- fiscal_year_sheets %>%
    filter(fiscal_year == fy) %>%
    pull(ss)
  
  for (m in months) {
    
    month_data <- read_sheet(ss, sheet = m) %>%
      janitor::clean_names() %>%
      mutate(
        fiscal_year = fy,
        month = m,
        year = if_else(
          month %in% month.name[7:12],
          fiscal_year - 1L,
          fiscal_year
        ),
        month_start = as.Date(
          paste("1", month, year),
          format = "%d %B %Y"
        ),
        date_click_twice_for_calendar = as.character(
          date_click_twice_for_calendar
        ),
        route_affected = as.character(route_affected),
        run_affected_24hr_format = as.character(
          run_affected_24hr_format
        ),
        driver = as.character(driver),
        bus = as.character(bus),
        reason = as.character(reason),
        reason_detail = as.character(reason_detail),
        notes = as.character(notes)
      )
    
    all_months <- bind_rows(all_months, month_data)
    
  }
}

last_complete_month <- floor_date(today(), "month") - months(1)

dropped_runs_chrt_dta <- all_months %>%
  filter(
    month_start >= last_complete_month - months(11),
    month_start <= last_complete_month
  ) %>%
  count(month_start, reason) %>%
  pivot_wider(
    names_from = month_start,
    values_from = n,
    values_fill = 0
  )


dw_chart_id <- "uLNyj"
if (publish_to_dw) {
  dw_data_to_chart(dropped_runs_chrt_dta, dw_chart_id, parse_dates = FALSE)
  dw_publish_chart(dw_chart_id, return_urls = FALSE) 
}


