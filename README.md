# Open Green Mountain Transit Data  

This repository provides publicly available data on ridership, fares, and stop-level boardings for Green Mountain Transit’s urban service area. To ensure data quality and accuracy, datasets are published within one month after the close of each reporting period (for example, January data will be available by March 1).

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

Fare data is provided by month at two levels of summarization:  

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
