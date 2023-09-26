## Basic points

- This Terraform configuration creates the following GCP resources:  
  - Cloud Storage bucket to store raw data (Data Lake) 
  - Big Query dataset - initial BQ dataset
- The file `main.tf` consists of the main Terraform blocks.
  - The structure of the resource block _**google_storage_bucket**_ you can find in the official Terraform documentation [here.](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
  - The structure of the resource block _**google_bigquery_dataset**_ you can find in the official Terraform documentation [here.](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset)
- The file `variables.tf` consists the values for some configurable parameters for Terraform blocks which are defined in the `main.tf`.

