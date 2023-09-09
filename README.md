# Dataset

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

## Set up dbt Cloud and deploy dbt models in the Production environment using provided workflow

Implementation details and the corresponding guidance you can find [here.](./notes/dbt_notes.md)

## Create a dashboard

Implementation details you can find [here.](./notes/dbt_dashboard.md)

