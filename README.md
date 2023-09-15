# Index

- [Dataset](#dataset)
- [Technologies](#technologies)
- [Data Pipeline Architecture and Workflow](#data-pipeline-architecture-and-workflow)
  - [Data Ingestion, Orchestration and Data Lake](#data-ingestion-orchestration-and-data-lake)
  - [Data Warehouse and Data Modeling](#data-warehouse-and-data-modeling)
  - [Data Visualization](#data_visualization)
- [Reproduce the project](#reproduce-the-project)
  - [Create a Google Cloud Project](#create-a-google-cloud-project)
  - [Set up dbt Cloud and deploy dbt models in Production](#set-up-dbt-cloud-and-deploy-dbt-models-in-production)


# Dataset

- This project is related to the processing of the Eurostat dataset: `"Gross domestic product (GDP) at current market prices by NUTS 2 regions"`. Eurostat online data code of this dataset: NAMA_10R_2GDP.
- The dataset is available at this [link.](https://ec.europa.eu/eurostat/web/products-datasets/-/nama_10r_2gdp)
- Metadata regarding this dataset you can find [here.](https://ec.europa.eu/eurostat/cache/metadata/en/reg_eco10_esms.htm)
- API for dataset access description is available at this [link.](https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API)
- The sourse of the Regions dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/sgm_reg/view)
- The sourse of the Units dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/unit/)

# Technologies

This project makes use the Google Cloud Platform, particularly Cloud Storage and BigQuery.

The Data Warehouse development was performed with dbt Cloud. 

# Data Pipeline Architecture and Workflow

## Data Ingestion, Orchestration and Data Lake

## Data Warehouse and Data Modeling

## Data Visualization

Dashbord implementation details, the corresponding description and visualizations you can find [here.](./notes/dashboard_notes.md)

# Reproduce the project

## Create a Google Cloud Project

After you create the project, you will need to create a _Service Account_: 
- ***IAM & Admin -> Service Accounts -> Create Service Account***
- Enter the following information:
  - _***Service Account ID***_. Provide `your own value` or hit `Generate` link.
  - Grant this service account access to the project with the following roles:
    - `BigQuery Admin`
    - `Storage Admin`
    - `Storage Object Admin`
    - `Viewer`

Create the Service Account credentials file.

- Service Account -> Manage Keys
- Add Key -> Create new key
  - Key type: `JSON`
- Save the created Service Account credentials file on the local machine.

## Set up dbt Cloud and deploy dbt models in Production

Implementation details and the corresponding guidance you can find [here.](./notes/dbt_notes.md)




