provider "google" {
  credentials = file(var.credentials)
  project     = "data-engineer-projects-2024"
  region      = "eu"
}

resource "google_storage_bucket" "data_bucket" {
  name     = "nyc_taxi_trips_2024"
  location = "EU"  # Change to EU, as per Google Cloud region codes
}

resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id = "nyc_taxi_trips"
  location   = "US"
}
  

