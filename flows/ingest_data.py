from from_web_to_gcs import from_web_to_gcs
from from_gcs_to_bq import from_gcs_to_bq
from prefect import flow, task


@flow()
def ingest_data():
    """Main flow to ingest data from web into Big Query"""

    from_web_to_gcs()
    from_gcs_to_bq()



if __name__ == "__main__":
    ingest_data()
