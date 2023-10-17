from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket
import proj_setup

# alternative to creating GCP blocks in the UI

credentials_block = GcpCredentials(
    service_account_info = proj_setup.service_account_credentials  
)
credentials_block.save("eurostat-gdp-gcp-creds", overwrite=True)


bucket_block = GcsBucket(
    gcp_credentials=GcpCredentials.load("eurostat-gdp-gcp-creds"),
    bucket=proj_setup.gcs_bucket_name, 
)
bucket_block.save("eurostat-gdp-gcs-bucket", overwrite=True)


