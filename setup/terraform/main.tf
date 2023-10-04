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
resource "google_storage_bucket" "data-lake-bucket" {
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

#Artifact registry for containers
resource "google_artifact_registry_repository" "eurostat-gdp-container-registry" {
  location      = var.region
  repository_id = var.registry_id
  format        = "DOCKER"
}
