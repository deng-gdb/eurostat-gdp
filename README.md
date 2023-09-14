# Dataset

- This project is related to the processing of the Eurostat dataset: `"Gross domestic product (GDP) at current market prices by NUTS 2 regions"`. Eurostat online data code of this dataset: NAMA_10R_2GDP.
- The dataset is available at this [link.](https://ec.europa.eu/eurostat/web/products-datasets/-/nama_10r_2gdp)
- Metadata regarding this dataset you can find [here.](https://ec.europa.eu/eurostat/cache/metadata/en/reg_eco10_esms.htm)
- The sourse of the Regions dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/sgm_reg/view)
- The sourse of the Units dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/unit/)

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

## Dashboard

- The dashboard used in this project was created in the Google Looker Studio. 
- The Looker Studio is treated in the project as Front-End visualization tool only. All table joins and other actions, required for the visualization, were made by the dbt Cloud.
- Due to the fact that Looker Studio Google Geo charts [doesn't support NUTs regions](https://support.google.com/looker-studio/answer/9843174#country&zippy=%2Cin-this-article), the "Map" page of the dashbord represents data for Country level regions only. The details regarding the NUTs regions you can find [here.](https://ec.europa.eu/eurostat/web/nuts/background)
- The dashbord is based on the dataset `eurostat_gdp_prod_core.facts_gdp_joined` from the corresponding DB Prod environment.
- The dashboard you can find [here.](https://lookerstudio.google.com/reporting/5cb1caed-76fb-4a2f-bbd3-b9e2bb8269b1)


