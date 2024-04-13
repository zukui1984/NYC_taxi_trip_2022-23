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
4. dbt - data build tool  
5. Power BI - Data visualisation  

## Diagram Structure

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

### dbt 
1. Once the data is successfully transfer into GCP - We can start the transform process
2. We are working with dbt portal -[LINK](https://cloud.getdbt.com/) for this. Therefore we don't need to do any installation locally.
3. To setup the project we need API key from GCP Service Accounts
4. Create new folder `staging` and first file `sources.yml` in Models folder - to declare tables that comes from data stores (BigQuery)
5. After that create query for green/yellow taxi data and named this as `stg_greendata_2022.sql` and `stg_yellowdata_2022.sql` = same with data for 2023
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-structure-list.JPG" alt="dbt structure" width="200">

6. Each query can be tested by running `Preview` then `dbt run` to see if works properly or not. But if you want run specific file you can do `dbt run --select greendata_2022`

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt_run_process-1.png" alt="dbt run 1" width="300">
  <img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-test.png" alt="dbt test" width="300">
</div>

<p>The <b>LEFT image</b> Run process</p>
<p>The <b>RIGHT image</b>Details after run the proces.</p>

7. Run `dbt build` so the data can be transfer into GCP BigQuery and the results look like this
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-gcp-dataset.JPG" alt="dbt gcp table" width="300">

9. Create new folder in Models - name `Core` and new file `fact_zones.sql` - To combine all cleaned data of greendatas and yellowdatas together. Lastly we'll see this diagram
<img src="https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/blob/master/images/dbt-lineage.JPG" alt="dbt lineage" width="500">

For all dbt coding information - Please see it here [LINK](https://github.com/zukui1984/NYC_taxi_trip_22_23-Data_Engineer/tree/master/dbt)

### Power BI

