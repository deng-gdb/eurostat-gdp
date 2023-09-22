# Index

- [Dataset](#dataset)
- [Technologies and Tools](#technologies-and-tools)
- [Data Pipeline Architecture and Workflow](#data-pipeline-architecture-and-workflow)
  - [Data Ingestion, Orchestration and Data Lake](#data-ingestion-orchestration-and-data-lake)
  - [Data Warehouse and Data Modeling](#data-warehouse-and-data-modeling)
  - [Data Visualization](#data-visualization)
- [Reproduce the project](#reproduce-the-project)
  - [Create a GCP project](#create-a-gcp-project)
  - [Set up dbt Cloud and deploy dbt models in Production](#set-up-dbt-cloud-and-deploy-dbt-models-in-production)


# Dataset

- This project is related to the processing of the Eurostat dataset: `"Gross domestic product (GDP) at current market prices by NUTS 2 regions"`. Eurostat online data code of this dataset: NAMA_10R_2GDP.
- The dataset is available at this [link.](https://ec.europa.eu/eurostat/web/products-datasets/-/nama_10r_2gdp)
- Metadata regarding this dataset you can find [here.](https://ec.europa.eu/eurostat/cache/metadata/en/reg_eco10_esms.htm)
- API for dataset access description is available at this [link.](https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API)
- The sourse of the Regions dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/sgm_reg/view)
- The sourse of the Units dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/unit/)

# Technologies and Tools

- Cloud: Google Cloud Platform
- Infrastructure as Code: Terraform
- Containerization: Docker
- Workflow Orchestration: Prefect
- Data Lake: Google Cloud Storage
- Data Warehouse: BigQuery
- Data Modeling and Transformations: dbt
- Data Visualization: Looker Studio
- Language: Python 

# Data Pipeline Architecture and Workflow

## Data Ingestion, Orchestration and Data Lake

## Data Warehouse and Data Modeling

The project uses Google BigQuery as a Data Warehouse.   
The Data Warehouse implementation details, Data Modeling guidance and the corresponding workflow you can find [here.](./notes/dbt_notes.md)

## Data Visualization

Dashbord implementation details, the corresponding description and visualizations you can find [here.](./notes/dashboard_notes.md)

# Reproduce the project

## Create a GCP project

To create a new Google Cloud project go to the [GCP dashboard](https://console.cloud.google.com/) and create a new project.


After you have created the project, you need to create a _Service Account_ in the project: 
- ***IAM & Admin -> Service Accounts -> Create Service Account***
- Enter the following information:
  - _***Service Account ID***_. Provide `your own value` or hit `Generate` link.
  - Grant this service account access to the project with the following roles:
    - `BigQuery Admin`
    - `Storage Admin`
    - `Storage Object Admin`
    - `Viewer`


After that create the Service Account credentials file.
- Service Account -> Manage Keys
- Add Key -> Create new key
  - Key type: `JSON`
- Save the created Service Account credentials file on the local machine.

Activate the following APIs in your GCP project:
- https://console.cloud.google.com/apis/library/iam.googleapis.com
- https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com



