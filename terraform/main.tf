provider "google" {
  credentials = file(var.credentials)
  project     = "data-engineer-projects-2024"
  region      = "us"
}

resource "google_storage_bucket" "data_bucket" {
  name     = "nyc_taxi_trips_2024"
  location = "US"  
}

resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id = "nyc_taxi_trips"
  location   = "US"
}
  

