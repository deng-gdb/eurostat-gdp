terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.GCP_PROJECT_ID
  region = var.region
  // credentials = file(var.credentials)  # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
}

# Data Lake Bucket
resource "google_storage_bucket" "bucket" {
  name          = "${var.data_lake_bucket}_${var.GCP_PROJECT_ID}" # Concatenating DL bucket & Project name for unique naming
  location      = var.region

  # Optional, but recommended settings:
  storage_class = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}

# DWH
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.raw_bq_dataset
  project    = var.GCP_PROJECT_ID
  location   = var.region
}

# Artifact registry for containers
resource "google_artifact_registry_repository" "artifact-repository" {
  location      = var.region
  repository_id = var.registry_id
  format        = "DOCKER"
}

# Compute Engine VM Instance

resource "google_compute_instance" "default" {
  name         = "eurostat-gdp-vm-instance"
  machine_type = "e2-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230918"
      size = "30"
      type="pd-standard"
      
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
      network_tier = "PREMIUM"
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.CE_SERVICE_ACCOUNT_EMAIL
    scopes = ["cloud-platform"]
  }

}