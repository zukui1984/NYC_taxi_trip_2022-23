-- Create a new table with transformed data
CREATE OR REPLACE TABLE `data-engineer-projects-2024.nyc_taxi_trip.greendata_trip_2022` AS
SELECT
    VendorID AS vendor_id,
    TIMESTAMP(lpep_pickup_datetime) AS pickup_datetime,
    TIMESTAMP(lpep_dropoff_datetime) AS dropoff_datetime,
    store_and_fwd_flag AS store_fwd_flag,
    RatecodeID AS rate_code_id,
    PULocationID AS pickup_location_id,
    DOLocationID AS dropoff_location_id,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    payment_type,
    trip_type,
    congestion_surcharge
FROM
    `data-engineer-projects-2024.nyc_taxi_trip.greendata_trip_2022`;
