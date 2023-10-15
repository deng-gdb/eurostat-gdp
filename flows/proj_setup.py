# enter your service account credentials from the json file you downloaded from google
# do not store these credentials in a publicly available repository!
service_account_credentials = {
  "type": "service_account",
  "project_id": "free-tier-project-397608",
  "private_key_id": "54b9b53b88c7e3a16e54bcf9847a29992e6b7655",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCqGg62WyHaC5Tm\nyeBL8CGYdm24IWh+do5YNn/BXKtxs2n3R/POPzDhdNHHvTvfdBQhJID4tCgMSwQI\nuL5CWcJfoBec7ym1mX1yMSIhD7Vp3u5qUBPV5HQqQ91XKy8eCITymylcDDZ7h4bI\nTOTYh6uAmhiaylejvHhiBxmUx/UnqSNmzG5VjZdMY6ZkD499EnA1AmynoImW6DcT\nmM0a/TbKZaO9UIXa4oSULIZtA4GtbE1d5yjh7mKBvv0ZG15/5tcr+Y7CdoCcKlfu\nzvmFv68V7QsaZrSmk83pzINi9JMJ+svdwAIUGwR37b+zS5nsihycUR/CcARSYJGV\nXToMkbK9AgMBAAECggEAE3ON3aP/s72xzg9lPwHLcbIPO2hUmOuJPQSkaNHmSAb+\nddjMRDg9KHbxmz/kNhoByEVymx4M21UDtdScax11CPbXZGqD8ECIVBPSxYmUkvH7\nfPxBvGqWrxOaHsLxLSPHwi9klCJQY6FclBCY9brT7Y2RhTfgvDhL4tfRgM451kpF\nEHmx6E/iFNEEtsSzrVS1NSyBUMGUhPB7C3J9ePHXZQU3JJPjjYg5iox+n2N9uDFV\nGxJlmm82abA0AN5Mi1LD+r2V0lXuPo2SxG0KTGh7zYG3c61BFDO6+vhiyjP9ndcr\n+j/bkr6qbCjaGLWt/OQ7CCVjIjvRsBinN+F2TK5ZUQKBgQDeMeI1koBzUA3iGhMM\n3WwhFvfhiJ+DJSpxUOoechpj5x7ygP+yE6mENhvUyqEGIzhk52VaO5UCwNIuSI1U\nlLWrPXGlnoamaMCcfAkDtBII9PYh3a5JlokW8889NiHfe5pHrDXLitT2Kh9kXWp1\ntvMyeBVFXynLF4umRCaSsycHjQKBgQDD+zx7Ww0gi7u5LWgA6zblfdnzrtpzHRXh\nBbGQHWKI3mv2nLRLmp4wHyRjuG5H74Skdo7mw35U0UIDItW1WkbccT13aLEBL5oX\nVmSu7mfG57iUdPctd0unfQJqL0o/sV0UvgJtK77JeEy4n34JtSjJdIC+R2bZPGQy\n+WZ4i7yz8QKBgFNWuHbJhT47B4oHp5+KqVTb7Yt9F/8zgHDSHY3f1EAmXvgsJDuh\nnlJFjTjJ642Gxk8qb1xhvqkys2LCuafAw0cAG9E33V8rKRtIdoUaFC2h23OmVwmo\n2bBvMArQc/IDxUEeuWqnnurZr76QPy75uMv0OF41rFJNeYaaRzF82qW9AoGBAJ9a\n5QYEtjrVhBIBesTsfVnDqHo9nkDl0ImFIKlnS1yxRqZjKzMiiSfl2qf/KiTx/C/i\nezXmlg2PjZaRN6Zbvqy2o1050lt9glUhmYKoNdgFSQ/lv6rHisuomVMQGtaJeH9K\nNRzh6iNV30Rr44cvN/f+9EREOLvBIFRWeNzh+tFxAoGBAILc6JaeIcMlUzPwuzny\nHnAh4qvQoeCG2sXM1XzO8uJkPJDevuWo0IiBq/58NUyW4td2StHwrKNgoFKRQ2n7\nMG5ZZ7b3cNNUEtsZ+a9y1c7+78gr0Qx+yCVmVLy1vvnqBdYEkMMMcEx98hMdMv9k\n+vMQdJgycIS1ljk/LTgPfAFn\n-----END PRIVATE KEY-----\n",
  "client_email": "service-account@free-tier-project-397608.iam.gserviceaccount.com",
  "client_id": "107579005190261272609",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/service-account%40free-tier-project-397608.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
} 

# enter your Google Cloud Storage bucket name here
gcs_bucket_name = "eurostat_gdp_data_lake_free-tier-project-397608"

# enter the full URL to your GitHub project repo
github_repository_url = "https://github.com/deng-gdb/eurostat-gdp.git"

# enter Docker image name
docker_image_name = "us-east1-docker.pkg.dev/free-tier-project-397608/eurostat-gdp-repository/eurostat-gdp:v1"

# enter your GCP Project ID
project_id = "free-tier-project-397608"
