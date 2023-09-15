>[Back to index](../README.md)

# Dashboard implementation notes

- The dashboard used in this project was created in the Google Looker Studio. 
- The Looker Studio is treated in the project as Front-End visualization tool only. All table joins and other actions, required for the visualization, were made in the dbt Cloud.
- Due to the fact that Looker Studio Google Geo charts [doesn't support NUTs regions](https://support.google.com/looker-studio/answer/9843174#country&zippy=%2Cin-this-article), the "Map" page of the dashbord represents data for Country level regions only. 

## Create Data source

- Open [Google Looker Studio](https://lookerstudio.google.com/)
- Create Data Source: Create -> Data source -> BigQuery
- Looker Studio requires authorization to connect to your BigQuery projects -> Authorize
- Choose your project, required dataset: `eurostat_gdp_prod_core` and table: `facts_gdp_joined` -> Connect
