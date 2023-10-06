from pathlib import Path
import pandas as pd
from prefect import flow, task
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp import GcpCredentials
import config_values
#from ...project_setup import setup
import os.path
import sys


@task(retries=3)
def fetch(dataset_url: str) -> pd.DataFrame:
    """Read data from Eurostat web into pandas DataFrame"""

    df = pd.read_table(dataset_url)
    return df


@task()
def write_local(df: pd.DataFrame, dataset_file_name: str) -> Path:
    """Write DataFrame out locally as csv file"""
    path = Path(f"{dataset_file_name}.csv")
    #df.to_csv(path)
    return path


@task()
def write_to_gcs_data_lake(path: Path) -> None:
    """Upload local csv file to GCS data lake bucket"""
    
    gcs_bucket_block = GcsBucket.load("eurostat-gdp-gcs-bucket")
    gcs_bucket_block.upload_from_path(from_path=path, to_path=path)
    
    return

@task()
def write_to_bq_table(df: pd.DataFrame) -> None:
    """Write DataFrame to BiqQuery table"""
  
    # remove from the dataframe the first row which contains the initial column names
    #df_modified = df.drop(index=0)

    #df.columns.str.replace(r"geo\TIME_PERIOD", "geo")
    '''
    df.rename(columns={"geo\TIME_PERIOD": "geo"}, inplace=True)

    df_modified = df.drop(index=0)

    data_top = df_modified.head() 
      
    print(data_top)
    '''

    gcp_credentials_block = GcpCredentials.load("eurostat-gdp-gcp-creds")

    # upload the dataframe to the BigQuery
    
    df.to_gbq(
        destination_table="eurostat_gdp_raw.nama-10r-2gdp",
        #project_id=config_values.project_id,
        project_id=setup.project_id,
        credentials=gcp_credentials_block.get_credentials_from_service_account(),
        chunksize=500_000,
        
        if_exists="append",
    )
    
    

    


@flow()
def ingest_data() -> None:
    """The main ETL function"""

    dataset_name = "NAMA_10R_2GDP"
    dataset_format = "TSV"
    dataset_url = f"https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/{dataset_name}?format={dataset_format}&compressed=false"
    dataset_file_name = "eurostat_gdp"

    directory = os.path.dirname(os.path.abspath("__file__"))
    cur_path = os.path.abspath("__file__")
    dest_rel_path = "../../project_setup"
    dest_path = os.path.join(cur_path, dest_rel_path)
    dest_path = '/home/dmitri/projects/eurostat-gdp/project_setup'
    sys.path.insert(0, dest_path)
    #from project_setup import setup
    import setup
    print(setup.project_id)
    print(sys.path)

    # fetch dataset from the eurostat site and put it into data frame
    #df = fetch(dataset_url)

    # Write DataFrame out locally as csv file
    #path = write_local(df, dataset_file_name)

    # Upload local csv file to GCS data lake bucket
    #write_to_gcs_data_lake(path)

    # Load data in the BigQuery table
    #write_to_bq_table(df)
 


if __name__ == "__main__":
    ingest_data()
