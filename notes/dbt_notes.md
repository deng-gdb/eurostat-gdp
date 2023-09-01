## Setting up dbt Cloud
1. Create a [dbt CLoud account](https://www.getdbt.com/signup/) or login to an existing account.
2. Go to Account Settings -> User Profile -> Personal Profile -> Linked Accounts -> Link -> Authorize dbt Cloud
      - Under choosen linked repo account -> Configure integration in GitHub -> Install dbt Cloud -> Install
3. Create a new project in this account: **Account Settings -> Projects -> New Project**
    - Name your project in the field **_Project name_**
    - **_Advanced Settings -> Project subdirectory_**. Specify the subdirectory of your repository which will contains your dbt project. For details see the following [guide](https://docs.getdbt.com/docs/build/projects#project-subdirectories).
    - Choose a connection: `BigQuery`
    - Configure your environment:
      - Specify the connection name
      - Upload a `Service Account JSON file`
      - Under **_Optional Settings_** section, enter the preferred value in the field **_Location_**. It is a GCP Location where dbt will create new Datasets for your project, i.e `us-east1`.
      - Under **_Development credentials_** section, enter any preferred name for the dataset in the field **_Dataset_**. In development, dbt will build your models into a dataset with this name, i.e. `eurostat`.
      - Test the connection and click on **_Continue_** once the connection is tested successfully.
    - Setup a Repository.
      - Choose the corresponding Repository from the provided list. This list is formed based on the information from your Repo account which is linked to your dbt User Profile.
  
