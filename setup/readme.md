## Basic Terraform implementation points

- Terraform is used in the project in order to create the following GCP resources:  
  - Cloud Storage bucket to store raw data (Data Lake) 
  - Big Query dataset - initial BQ dataset
- It was decided don't create an VM instance using Terraform in order to decrease the quantity of software which should be installed on local machine. Instead that, a VM instance should be created mannually through GCP Project Dashboard, and then Terraform should be installed in this VM instance.
- Terraform configuration in the project consists the following files:  
  - The file `main.tf` consists of the main Terraform blocks.  
    - The structure of the resource block _**google_storage_bucket**_ you can find in the official Terraform documentation [here.](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
    - The structure of the resource block _**google_bigquery_dataset**_ you can find in the official Terraform documentation [here.](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset)
  - The file `variables.tf` consists the values for some configurable parameters for Terraform blocks which are defined in the `main.tf`.

