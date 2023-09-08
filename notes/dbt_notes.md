
## 1. Setting up dbt Cloud project.
1. Create a [dbt CLoud account](https://www.getdbt.com/signup/) or login to an existing account.
2. Go to **_Account Settings_** -> **_User Profile_** -> **_Personal Profile_** -> **_Linked Accounts_** -> **_Link_** -> **_Authorize dbt Cloud_**
      - Under choosen linked repo account -> Configure integration in GitHub -> Install dbt Cloud -> Install
3. Create a new project in this account: **Account Settings -> Projects -> New Project**
    - **_Project name:_** `eurostat-gdp`
    - **_Advanced Settings -> Project subdirectory_**. Specify the subdirectory of your repository which will contains your dbt project. For details see the following [guide](https://docs.getdbt.com/docs/build/projects#project-subdirectories).
    - Choose a connection: `BigQuery`
    - Configure your environment:
      - **_Connection:_** `BigQuery`
      - Upload a `Service Account JSON file`
      - **_Optional Settings_** section, enter the preferred value in the field **_Location_**. It is a GCP Location where dbt will create new Datasets for your project, i.e `us-east1`.
      - **_Development credentials_** section, field **_Dataset:_** `eurostat_gdp`. 
      - Test the connection and click on **_Continue_** once the connection is tested successfully.
    - Setup a Repository for the dbt project.
      - Choose the corresponding Repository from the provided list. This list is formed based on the information from your Repo account which is linked to your dbt User Profile.
  
## 2. Setting up GitHub repository.
- in the selected repository create the following branches: 
  - **dbt-dev.** This is the individual branch of the developer. Each developer from dev team has its own developing branch.
  - **dbt-qa.** This branch contains all merged changes from the whole dev team.
  - **dbt-prod.** It is actually branch for prod environment. This branch is used to separate dbt code from the other code in the repository which is stored in the main branch.

## 3. Configure your Dev environment in the dbt Cloud IDE.
- Open dbt Cloud IDE. It is your Dev environment.
- Setup working branch for the IDE: `dbt-dev` 
