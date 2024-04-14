# NYC Green & Yellow Taxi Trip 2022-2023
Yellow and green taxi trip records include fields capturing pick-up and drop-off dates/times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and driver-reported passenger counts. Dataset source - [LINK](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

**Yellow Taxi**: The famous NYC yellow taxis that provide transportation exclusively through street hails. The number of taxicabs is limited by a finite number of medallions issued by the TLC. You can access this mode of transportation by standing in the street and hailing an available taxi with your hand. The pickups are not pre-arranged.

**Green Taxi**: The outfit of their vehicles with green borough taxi branding, meters, credit card machines, and ultimately the right to accept street hails in addition to pre-arranged rides.

## Possible issues 
1. Which taxi company dominating the market? Can this implication giving an impact on competition and consumer choice in taxi industry?
2. Are there any inconsistencies in data, such as driving trip distances or fare amounts?
3. Are there any significant difference between the average trip distances of green and yellow taxis?
4. Any possibilities of overcharging price fare for customers and which payment type are they using?

## Important Points
* Using *.parquet* dataset of yellow and green taxi from **2022-2023** 
* Data structure isn't always same with other years eg. these aren't included `pickup_longitude, pickup_latitude, dropoff_longitude, and dropoff_latitude`
* As I don't own Power BI business account - there are **some limitation** with Desktop version incl doing data cleaning

## Table Content
1. Google Cloud Platform (GCP): BigQuery & GCS - Data Warehouse
2. Terraform - Infrastructure as Code (IaC) 
3. Mage AI - Data Pipeline
4. GCP BigQuery - Data Warehouse 
5. dbt - data build tool  
6. Power BI - Data Visualisation
7. Conclusion

## Diagram Structure
<div style="display: flex; justify-content: space-between;">
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/data-engineer-diagram.JPG" alt="diagram" width="600">
</div>

### Google Cloud Platform (GCP)
1. Sign up on GCP platform https://cloud.google.com/
2. Install Google SDK https://cloud.google.com/sdk/docs/install
    - Authenticate the SDK with your GCP account `gcloud auth login` then set default of project `gcloud config set project PROJECT_ID`
3. Enable API Library - **Compute Engine, Storage Admin, Dataproc, BigQuery**
4. Create API Key on Service Accounts (IAM) and this key information will be use on Terraform and Mage AI

### Terraform
1. Setup the installation - [LINK](https://developer.hashicorp.com/terraform/install)
2. Create `main.tf` using the information from GCP account eg. dataset, storage, credentials and instance
3. Then run `terraform init`
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/raw/master/images/terraform-init.png" alt="terraform init" width="400">

4. After run `terraform plan` and `terraform apply`
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/terraform-apply.png" alt="terraform plan + apply" width="400">

### Mage AI - ELT/ETL
1. Prequisite: **Docker** must been setup before installing mage AI
2. Install `docker pull mageai/mageai:latest` and run this code
```
git clone https://github.com/mage-ai/compose-quickstart.git mage-ai \
&& cd mage-ai \
&& cp dev.env .env && rm dev.env \
&& docker compose up
```
3. Run `http://localhost:6789` to see Mage AI
4. Setup Google Credentials on Mage AI based on GCP Service Account API key
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/mage-gcp-config.JPG" alt="gcp confog" width="300">

5. Create _Data Loader_ for `greendata_2022/2023` and `yellowdata_2022/2023`- [code link](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/mage-ai/data_loader-load_greendata_2022.py) to pull out data and _Data Exporter_ - [code link](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/mage-ai/data_export-export_greendata_2022.py) to transfer it into **Google Cloud Storage**
-    The code structure are similiar each other. Therefore I only add one coding file
-    Data Loader/Exporter process here are aiming to transfer directly to Google Cloud Storage

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/mage-data-loader-result.JPG" alt="data loader" width="400">
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/mage-data-export-result.JPG" alt="data export" width="400">
</div>
<p>The <b>LEFT image (Data Loader)</b> shows the result of the data loader process, which loads the NYC taxi trip data into the system for further processing</p>
<p>The <b>RIGHT image (Data Exporter)</b> shows the result of the data export process, which exports the processed data for use in other applications or analysis tools.</p>

6. The Mage AI structure
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/mage-structure.JPG" alt="mage structure" width="200">

7. The ELT/ETL workflow tree looks like this diagram
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/mage-trees.JPG" alt="mage tree" width="600">

### GCP BigQuery 
1. Once the data is successfully transfered in Cloud Storage we can create a table like this
```sql
CREATE OR REPLACE TABLE `data-engineer-projects-2024.nyc_taxi_trip.yellowdata_trip_2022` AS
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
    `data-engineer-projects-2024.nyc_taxi_trip.yellowdata_trip_2022`;
```
2. Now we have similiar data list as `greendata_trip_2022` because before `yellowdata_trip_2022` was still incl. **airport_fee**
3. We can combine now the table of `greendata_trip_2022` + `greendata_trip_2023` into `greendata_trip_total` (same with yellowdata)
```sql
CREATE OR REPLACE TABLE `data-engineer-projects-2024.nyc_taxi_trip.greendata_trip_total` AS
SELECT *
FROM `data-engineer-projects-2024.nyc_taxi_trip.yellowdata_trip_2022`
UNION ALL
SELECT *
FROM `data-engineer-projects-2024.nyc_taxi_trip.greendata_trip_2023`
```

### dbt 
1. The transform process is using dbt official plattform - [LINK](https://cloud.getdbt.com/) for this. Therefore we don't need to do any installation locally.
2. To setup the project we need API key from GCP Service Accounts
3. Create new folder `staging` and first file `sources.yml` in Models folder - to declare tables that comes from data stores (BigQuery)
4. After that create query for green/yellow taxi data and named this as `stg_greendata_2022.sql` and `stg_yellowdata_2022.sql` = same with data for 2023
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-structure-list.JPG" alt="dbt structure" width="200">

5. Each query can be tested by running `Preview` then `dbt run` to see if works properly or not. But if you want run specific file you can do `dbt run --select greendata_2022`

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt_run_process-1.png" alt="dbt run 1" width="300">
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-test.png" alt="dbt test" width="300">
</div>

<p>The <b>LEFT image</b> Run process</p>
<p>The <b>RIGHT image</b>Details after run the proces.</p>

6. Run `dbt build` so the data can be transfer into GCP BigQuery and the results look like this
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-gcp-dataset.JPG" alt="dbt gcp table" width="300">

7. Create new folder in Models - name `Core` and new file `fact_zones.sql` - To transform and combine all cleaned data of greendatas and yellowdatas together.
-    `stg_greendata_total.sql` - [LINK](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/dbt/models/staging/stg_greendata_total.sql)
-    `stg_yellowdata_total.sql` - [LINK](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/dbt/models/staging/stg_yellowdata_total.sql)
-    `facts_zones` (UNION both tables) - [LINK](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/dbt/models/core/fact_zones.sql)

8. Lastly we'll see this diagram
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-lineage.JPG" alt="dbt lineage" width="500">

For all dbt coding information - Please see it here [LINK](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/tree/master/dbt)

### Power BI
1. To collect data from BigQuery. We must choose "Get Data" -> "Database" -> "Google BigQuery"
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/powerbi-data-collect.JPG" alt="power bi data collect" width="300">

3. Now we have a transformed data from dbt - We must see if there are still missing/incorrect data in this dataset. For this we need to compare based on documentation **greendata and yellowdata** that provide here [LINK](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)

4. Here we can find several column that has missing and incorrect values eg. `vendor_id, service_type, rate_code_id, payment_type, congestion_surcharge`
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/powerbi-data-cleaning.JPG" alt="power bi data cleaning" width="200">

5. For data visualisation we are using line-,pie-,bar-,column-, and donut chart. The complete charts will look like this

<div style="display: flex; justify-content: space-between;">
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/power_bi_screenshot.JPG" alt="power bi viz" width="600">
</div>

## Conclusion 

## Findings
1. Green taxis had much longer average trip distances (53km) compared to yellow taxis (6km).
2. VeriFone Inc. was the dominant taxi company with 58 million users, while Creative Mobile Technologies had 23 million users.
3. A large portion (20.32%) of trips had "Negotiated fares" instead of standard rates.
4. There was a difference of around 0.5 miles between the starting and ending taximeter readings on average trips.
5. Credit card payments had longer average trip distances (3.2 miles) compared to cash payments (1 mile).

The total number of passengers was 109 million, with tolls fees amounting to $42.93 million.

The data highlights potential issues like service imbalances, lack of competition, fare transparency concerns, taximeter inaccuracies, and possible payment biases that may need to be addressed in the NYC taxi industry.

## Suggestions
1. Service imbalance between taxi types:
-    Review regulations and implement incentives to encourage more balanced utilization across different trip distances.
2. Taxi company dominance:
-    Promote fair competition by removing barriers for smaller companies to enter the market.
-    Review licensing frameworks to prevent unfair advantages.
3. Prevalence of negotiated fares:
-    Implement stricter regulations and transparency requirements for negotiated fares.
-    Consider setting maximum limits based on distance and time.
4. Taximeter discrepancies:
-    Establish regular calibration programs and explore GPS-based fare calculation systems.
-    Impose penalties for inaccurate or tampered taximeters.
5. Payment type biases:
-    Investigate factors behind the correlation between payment type and trip distance.
-    Implement training and policies to prevent discrimination based on payment methods.

