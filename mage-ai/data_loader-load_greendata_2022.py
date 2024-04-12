import io
import pandas as pd
import requests
import pyarrow.parquet as pq
import datetime

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    urls = [
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-01.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-02.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-03.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-04.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-05.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-06.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-07.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-08.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-09.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-10.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-11.parquet',
        'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-12.parquet'
    ]

    dataframes = []
    for url in urls:
        response = requests.get(url)
  
        table = pq.read_table(io.BytesIO(response.content))
        
        df = table.to_pandas()
        dataframes.append(df)

    ## Concatenate the dataframes into a single dataframe
    df = pd.concat(dataframes, ignore_index=True)

    # Apply datetime conversion to lpep_pickup_datetime column
    df['lpep_pickup_datetime'] = df['lpep_pickup_datetime'].apply(lambda d: datetime.datetime.fromtimestamp(d.timestamp()).strftime('%Y-%m-%d %H:%M:%S'))

    return df


@test
def test_output(*outputs, **kwargs) -> None:
    """
    Template code for testing the output of the block.
    """
    assert all(output is not None for output in outputs), 'One or more outputs are undefined'
