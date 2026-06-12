
library(httr)
library(readr)
library(dplyr)
library(here)
library(lubridate)
library(tidyr)
library(DatawRappr)

i_am("scripts/on_time_performance.R")

publish_to_dw <- TRUE

swiftly_api_key <- Sys.getenv("SWIFTLY_API_KEY")
swiftly_agency_key <- Sys.getenv("SWIFTLY_AGENCY_KEY")

base_url <- paste0(
  "https://api.goswift.ly/otp/",
  swiftly_agency_key,
  "/otp-stats"
)

# Most recent complete month
last_complete_month <- floor_date(today(), "month") %m-% months(1)

# Last 12 complete months
months <- seq(
  last_complete_month %m-% months(11),
  last_complete_month,
  by = "month"
)

results <- data.frame()

for (i in seq_along(months)) {
  
  month_start <- months[i]
  month_end <- ceiling_date(month_start, "month") - days(1)
  
  response <- GET(
    base_url,
    query = list(
      startDate = format(month_start, "%m-%d-%Y"),
      endDate = format(month_end, "%m-%d-%Y"),
      allowableEarly = 1,
      allowableLate = 5,
      dropOffOnlyStops = "earliesAsOnTime",
      lastStopOfTrip = "earliesAsOnTime",
      stopType = "scheduleAdherenceStops",
      format = "csv",
      routes = "1,2,4,5,6,7,8,9,11,86,96"
      # groupBy = "ROUTE_SHORT_NAME"
    ),
    add_headers(
      Authorization = swiftly_api_key
    ),
    accept("text/csv")
  )
  
  stop_for_status(response)
  
  monthly_df <- response |>
    content("text", encoding = "UTF-8") |>
    I() |>
    read_csv() |>
    mutate(
      month = month_start
    )
  
  results <- bind_rows(results, monthly_df)
}

otp_df <- results

# Trying to make these match what I see in the portal
otp_df_tidy <- otp_df %>%
  pivot_longer(
    cols = any_of(c("num_stops_early", "num_stops_late", "num_stops_ontime", "num_missing_stops_unexplained", "num_missing_stops_explained"))
  ) %>%
  select(month, num_scheduled_stops, num_observed_stops, everything()) %>%
  # filter(name %in% )
  mutate(
    pct_otp = value / num_observed_stops,
    pct_completeness = value / num_scheduled_stops,
    # Update name
    variable = case_when(
      name == "num_stops_early" ~ "Early",
      name == "num_stops_ontime" ~ "On time",
      name == "num_stops_late" ~ "Late",
      name == "num_missing_stops_unexplained" ~ "Missing",
      name == "num_missing_stops_explained" ~ "Adjusted",
      TRUE ~ NA
    )
  ) 

completeness_chrt_dta <- otp_df_tidy %>%
  mutate(
    pct_completeness = pct_completeness * 100,
    variable = case_when(
      variable %in% c("Early", "On time", "Late") ~ "Observed",
      TRUE ~ variable
    ),
  ) %>%
  group_by(month, variable) %>%
  summarise(
    pct_completeness = sum(pct_completeness)
  ) %>%
  ungroup() %>%
  mutate(
    variable = factor(variable, levels = c("Observed", "Missing", "Adjusted"))
  ) %>%
  arrange(variable) %>%
  select(month, variable, pct_completeness) %>%
  pivot_wider(
    names_from = "month",
    values_from = "pct_completeness"
  )


dw_chart_id <- "ZEdGM"
if (publish_to_dw) {
  dw_data_to_chart(completeness_chrt_dta, dw_chart_id, parse_dates = FALSE)
  dw_publish_chart(dw_chart_id, return_urls = FALSE) 
}


otp_chrt_dta <- otp_df_tidy %>%
  filter(variable %in% c("Early", "On time", "Late")) %>%
  mutate(
    variable = factor(variable, levels = c("Early", "On time", "Late")),
    pct_otp = pct_otp * 100
  ) %>%
  arrange(variable) %>%
  select(month, variable, pct_otp) %>%
  pivot_wider(
    names_from = "month",
    values_from = "pct_otp"
  )


dw_chart_id <- "A12sD"
if (publish_to_dw) {
  dw_data_to_chart(otp_chrt_dta, dw_chart_id, parse_dates = FALSE)
  dw_publish_chart(dw_chart_id, return_urls = FALSE) 
}


