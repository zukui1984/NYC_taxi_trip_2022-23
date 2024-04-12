with tripdata AS (
    select * from {{ source("staging", "greendata_trip_total") }}
)

SELECT  
    -- identifiers
    vendor_id,
    cast(pickup_location_id as integer) as pickup_location_id,
    cast(dropoff_location_id as integer) as dropoff_location_id,
    cast(rate_code_id as integer) as rate_code_id,

    -- trip info
    cast(passenger_count as integer) as passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    store_fwd_flag,
     
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    cast(payment_type as numeric) as payment_type,
    cast(congestion_surcharge as numeric) as congestion_surcharge

FROM tripdata 
