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
1. Google Cloud Platform (GCP) 
2. Terraform - Infrastructure as Code (IaC) 
3. Mage AI ELT/ETL - Orchestration tool  
4. dbt - data build tool  
5. Power BI - Data visualisation  

## Diagram Structure

### Google Cloud Platform (GCP)
1. Sign up on GCP platform https://cloud.google.com/
2. Install Google SDK https://cloud.google.com/sdk/docs/install
    - Authenticate the SDK with your GCP account "gcloud auth login" then set default of project "gcloud config set project PROJECT_ID"
4. Enable API Library - Compute Engine, Storage Admin, Dataproc, BigQuery
5. Create API Key on Service Accounts (IAM)

### Terraform
```cd Credit-card-approval-prediction-classificatio```
<pip install mage-ai>

### Mage AI - ELT/ETL

### dbt 

### Power BI

