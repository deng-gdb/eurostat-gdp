# Index

- [Dataset](#dataset)
- [Technologies and Tools](#technologies-and-tools)
- [Data Pipeline Architecture and Workflow](#data-pipeline-architecture-and-workflow)
  - [Data Ingestion, Orchestration and Data Lake](#data-ingestion-orchestration-and-data-lake)
  - [Data Warehouse and Data Modeling](#data-warehouse-and-data-modeling)
  - [Data Visualization](#data-visualization)
- [Reproduce the project](#reproduce-the-project)
  - [Prerequisites](#prerequisites)
  - [Create a GCP project](#create-a-gcp-project)
  - [Create and setup a VM instance in GCP Compute Engine](#create-and-setup-a-vm-instance-in-gcp-compute-engine)
  - [Install and setup Google Cloud SDK on local machine](#install-and-setup-google-cloud-sdk-on-local-machine)
  - [Set up SSH access to the Compute Engine VM instances](#set-up-ssh-access-to-the-compute-engine-vm-instances)  
    - [Create an SSH key pair on local machine](#create-an-ssh-key-pair-on-local-machine)
  - [Set up dbt Cloud and deploy dbt models in Production](#set-up-dbt-cloud-and-deploy-dbt-models-in-production)


# Dataset

- This project is related to the processing of the Eurostat dataset: `"Gross domestic product (GDP) at current market prices by NUTS 2 regions"`. Eurostat online data code of this dataset: NAMA_10R_2GDP.
- The dataset is available at this [link.](https://ec.europa.eu/eurostat/web/products-datasets/-/nama_10r_2gdp)
- Metadata regarding this dataset you can find [here.](https://ec.europa.eu/eurostat/cache/metadata/en/reg_eco10_esms.htm)
- API for dataset access description is available at this [link.](https://wikis.ec.europa.eu/display/EUROSTATHELP/Transition+-+from+Eurostat+Bulk+Download+to+API)
- The sourse of the Regions dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/sgm_reg/view)
- The sourse of the Units dimension you can find [here.](http://dd.eionet.europa.eu/vocabulary/eurostat/unit/)

# Technologies and Tools

- Cloud: Google Cloud Platform
- Infrastructure as Code: Terraform
- Containerization: Docker
- Workflow Orchestration: Prefect
- Data Lake: Google Cloud Storage
- Data Warehouse: BigQuery
- Data Modeling and Transformations: dbt
- Data Visualization: Looker Studio
- Language: Python 

# Data Pipeline Architecture and Workflow

## Data Ingestion, Orchestration and Data Lake

## Data Warehouse and Data Modeling

The project uses Google BigQuery as a Data Warehouse.   
The Data Warehouse implementation details, Data Modeling guidance and the corresponding workflow you can find [here.](./notes/dbt_notes.md)

## Data Visualization

Dashbord implementation details, the corresponding description and visualizations you can find [here.](./notes/dashboard_notes.md)

# Reproduce the project

## Prerequisites

The following items could be treated as prerequisites in order to reproduce the project:

- An active [GCP account.](https://cloud.google.com)
- It is supposed that we are going to connect to GCP VM from the local machine trough the SSH.
- (Optional) A SSH client. It is supposed that you are using a Terminal and SSH.

## Create a GCP project

- To create a new Google Cloud project go to the [GCP dashboard](https://console.cloud.google.com/) and create a new project.
- After you have created the project, you need to create a _Service Account_ in the project: 
  - ***IAM & Admin -> Service Accounts -> Create Service Account***
  - Enter the following information:
    - _***Service Account ID***_. Provide `your own value` or hit `Generate` link.
    - Grant this service account access to the project with the following roles:
      - `BigQuery Admin`
      - `Storage Admin`
      - `Storage Object Admin`
      - `Viewer`
- After that create the Service Account credentials file.
  - **Service Account** -> **Manage Keys** -> **Add Key** -> **Create new key**  
  - Chose Key type: `JSON`
- Download the created Service Account credentials file on the local machine and store it in your home folder, i.e. in the `$HOME/.google/`.  
- Then activate the following APIs in your GCP project:  
  - https://console.cloud.google.com/apis/library/iam.googleapis.com
  - https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com

## Create and setup a VM instance in GCP Compute Engine

- Go the your GCP project dashboard _Compute Engine_ -> _VM instances_ -> _Create instance_
- Add the following information (the provided iformormation complies with the GCP Free Tier limitations):
  -  Name: whatever you want
  -  Region: `us-east1` (this is a free tier limit)
  -  Series: `E2`
  -  Machine type: `e2-micro` (this is a free tier limit)
  -  Boot disk:
     - boot disk type: `Standard persistent disk` (this is a free tier limit)
     - operating system: `Ubuntu`
     - version: `Ubuntu 20.04 LTS`
     - size: `30Gb`

## Install and setup Google Cloud SDK on local machine

- Download Google Cloud SDK from [this link](https://cloud.google.com/sdk/docs/install-sdk#linux) and install it.
- Initialize the SDK following [these instructions.](https://cloud.google.com/sdk/docs/install-sdk)
  - Run `gcloud init` from a terminal and follow the instructions:
    - The system will generate a link and will ask you to go to the link in your browser.
    - When you will go to this link Google will generate the verification code in gcloud CLI on the machine you want to log into.
    - Copy this code and paste it into your terminal window prompt. 
  - Make sure that your project is selected with the command `gcloud config list`
   
## Set up SSH access to the Compute Engine VM instances

- Create an SSH key pair on local machine.  
  - If you connect to GCP Compute Engine virtual machine (VM) instances using third party tools or OpenSSH, you need to add a key to your VM before you can connect. If you don't have an SSH key, you must create one.
  - Create SSH key pair in accordance with the following GCP guidance: [Create SSH keys](https://cloud.google.com/compute/docs/connect/create-ssh-keys)  
    - Open a terminal window and run the following command: `ssh-keygen -t rsa -f ~/.ssh/<key_file_name> -C <user_name> -b 2048`, where:   
      - <key_file_name>: the name for your SSH key file, replace it by your own value  
      - <user_name>: your username on the VM, replace it by your own value  
    - This comand will create two files in the .ssh folder: <key_file_name> (private key) and <key_file_name>.pub (public key)
  - Upload the created ssh public key to GCP  
    - Copy the content of the <key_file_name>.pub  
    - Go to the your `GCP project console -> Compute Engine -> Settings -> Metadata -> SSH keys -> Add SSH Key`.
    - Insert the copied content of the <key_file_name>.pub -> Save.
    - All instances in this project will use this ssh key.
- Cnfigure SSH access on the local machine.
  1. Start the created VM instance in the Google Cloud dashboard.
  2.    
