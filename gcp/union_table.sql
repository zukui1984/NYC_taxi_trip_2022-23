CREATE OR REPLACE TABLE `data-engineer-projects-2024.nyc_taxi_trip.yellowdata_trip_total` AS
SELECT *
FROM `data-engineer-projects-2024.nyc_taxi_trip.yellowdata_trip_2022`
UNION ALL
SELECT *
FROM `data-engineer-projects-2024.nyc_taxi_trip.yellowdata_trip_2023`
