{{ config(materialized="table") }}


with
    green_tripdata as (
        select *, 'green' as service_type from {{ ref("stg_greendata_total") }}
    ),
  
    yellow_tripdata as (
        select *, 'yellow' as service_type from {{ ref("stg_yellowdata_total") }}
    ),
   -- combine green and yellow data 
    trips_unioned as (
        select *
        from green_tripdata
        union all
        select *
        from yellow_tripdata
    )

select
    trips_unioned.service_type,
    trips_unioned.vendor_id,
    trips_unioned.pickup_datetime,
    trips_unioned.dropoff_datetime,
    trips_unioned.store_fwd_flag,
    trips_unioned.rate_code_id,
    trips_unioned.pickup_location_id,
    trips_unioned.dropoff_location_id,
    trips_unioned.passenger_count,
    trips_unioned.trip_distance,
    trips_unioned.fare_amount,
    trips_unioned.extra,
    trips_unioned.mta_tax,
    trips_unioned.tip_amount,
    trips_unioned.tolls_amount,
    trips_unioned.improvement_surcharge,
    trips_unioned.total_amount,
    trips_unioned.payment_type,
    trips_unioned.congestion_surcharge
from trips_unioned
