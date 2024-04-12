provider "google" {
  credentials = file(var.credentials)
  project     = "data-engineer-projects-2024"
  region      = "eu"
}


resource "google_storage_bucket" "data_bucket" {
  name     = "nyc_taxi_trips_2024"
  location = "eu"
}

resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id = "nyc_taxi_trips"
  location   = "US"
}

resource "google_compute_instance" "data_vm" {
  name         = "project-instance"
  machine_type = "e2-medium"
  zone         = "us-west1"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
