variable "GCP_PROJECT_ID" {
  description = "Your GCP Project ID"
}

variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default = "us-east1"
  type = string
}

variable "storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default = "STANDARD"
}

variable "data_lake_bucket" {
  description = "The name of the Cload Storage bucket which is used as a Data Lake"
  type = string
  default = "eurostat_data_lake"
}

variable "raw_bq_dataset" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type = string
  default = "eurostat_gdp_raw"
}
