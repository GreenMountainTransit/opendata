# Green Mountain Transit Open Data  

This repository provides publicly available data on ridership, fares, and stop-level boardings for Green Mountain Transit’s urban service area.

## Ridership  

Ridership performance can be readily visualized in the [Ridership Tracker Dashboard](https://GreenMountainTransit.github.io/opendata/ridership_tracker.html). Raw data files are available in the [`/data/ridership/`](./data/ridership/) directory.

For each route and month, the following metrics are provided:

- **Total Ridership**: Total passenger boardings during the month.  
- **Total Vehicle Hours**: Total hours vehicles operated in revenue service during the month.  
- **Weekday Ridership**: Passenger boardings during weekday service.  
- **Weekday Vehicle Hours**: Revenue service hours operated on weekdays.  
- **Saturday Ridership**: Passenger boardings during Saturday service.  
- **Saturday Vehicle Hours**: Revenue service hours operated on Saturdays.  
- **Sunday Ridership**: Passenger boardings during Sunday service.  
- **Sunday Vehicle Hours**: Revenue service hours operated on Sundays.

## Fares  
 
Fare transactions trends can be visualized in the [Fare Tracker Dashboard](https://GreenMountainTransit.github.io/opendata/fare_tracker.html). Raw data files are available in the [`/data/fares/`](./data/fares/) directory.

Fare data are summarized monthly and reported at two levels of detail:  

- **Fare group**: A high-level categorization representing the rider’s payment tier or funding source (for example, regular fare, discount fare, or sponsored programs).  
- **Fare type**: The specific product classification within each fare group.

Fare data represent completed transactions and may not directly correspond one-to-one with passenger boardings.

## Boarding Estimates by Stop

Boarding estimates can be visualized in the [Stops Dashboard](https://GreenMountainTransit.github.io/opendata/stop_tracker.html). Raw data files are available in the [`/data/stops/`](./data/stops/) directory.

Stop-level boarding estimates are derived by associating fare transaction timestamps with vehicle GPS locations and then matching each transaction to the nearest stop along the corresponding route. Because this methodology relies on spatial and temporal inference, stop-level boarding counts are subject to error and should be interpreted as approximate.

As a result:

- Boarding estimates by stop will not sum to published ridership totals.
- Stop-level data should not be aggregated to produce route-level ridership.
- Route-level ridership analysis should rely on the ridership datasets described above.

## Data Limitations and Terms of Use

These data are provided for informational and analytical purposes only and are made available to the public without warranty. Green Mountain Transit makes no guarantees regarding completeness, accuracy, or fitness for any particular purpose and shall not be held liable for errors or omissions in the data, including content, positional accuracy, or interpretation. These data should not be construed as legal documents. Users should consult primary source materials where verification is required.

These datasets are intended to support high-level analysis, transparency, and exploratory research. They may not be suitable for detailed operational, financial, or regulatory reporting without additional validation. Stop-level boarding estimates and other inferred values are subject to methodological limitations, as described above, and should be interpreted with care.

GMT reserves the right to revise previously published datasets. Substantive revisions will be documented in the CHANGELOG.

To ensure data quality and accuracy, datasets are published within one month after the close of each reporting period (for example, January data will be available by March 1).

## Contact and Feedback

Questions, feedback, or issue reports related to these datasets may be submitted via this repository or by contacting **planning@ridegmt.com**.

We welcome feedback that helps improve data quality, documentation, and usability.

