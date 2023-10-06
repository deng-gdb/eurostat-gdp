from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket
from prefect_gcp.cloud_run import CloudRunJob
import block_vars

# alternative to creating GCP blocks in the UI

credentials_block = GcpCredentials(
    service_account_info = block_vars.service_account_credentials  
)
credentials_block.save("eurostat-gdp-gcp-creds", overwrite=True)


bucket_block = GcsBucket(
    gcp_credentials=GcpCredentials.load("eurostat-gdp-gcp-creds"),
    bucket=block_vars.gcs_bucket_name, 
)
bucket_block.save("eurostat-gdp-gcs-bucket", overwrite=True)

