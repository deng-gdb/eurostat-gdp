# Index

- [Dataset](#dataset)
- [Technologies and Tools](#technologies-and-tools)
- [Data Pipeline Architecture and Workflow](#data-pipeline-architecture-and-workflow)
  - [Cloud Infrastructure with Terraform](#cloud-infrastructure-with-terraform)
  - [Orchestration](#orchestration)
  - [Data Ingestion and Data Lake](#data-ingestion-and-data-lake)
  - [Data Warehouse and Data Modeling](#data-warehouse-and-data-modeling)
  - [Data Visualization](#data-visualization)
- [Reproduce the project](#reproduce-the-project)
  - [Set up project environment](#set-up-project-environment)
    - [Prerequisites](#prerequisites)
    - [Create a GCP project](#create-a-gcp-project)
    - [Install and setup Google Cloud SDK on local machine](#install-and-setup-google-cloud-sdk-on-local-machine)
    - [Install Terraform on local machine](#install-terraform-on-local-machine)
    - [Create GCP project infrastructure with Terraform](#create-gcp-project-infrastructure-with-terraform)
      
    - [Create a VM instance in GCP Compute Engine](#create-a-vm-instance-in-gcp-compute-engine)
    
    - [Set up SSH access to the Compute Engine VM instances on local machine](#set-up-ssh-access-to-the-compute-engine-vm-instances-on-local-machine)
    - [Set up the created VM instance in GCP](#set-up-the-created-vm-instance-in-gcp)
      - [Start SSH connection to VM instance](#start-ssh-connection-to-vm-instance)
      - [Upload Google Application credentials to VM instance](#upload-google-application-credentials-to-vm-instance)
      - [Install Docker](#install-docker)
      - [Install Docker Compose](#install-docker-compose)
      - [Clone the project repo in the VM instance](#clone-the-project-repo-in-the-vm-instance)
      - [Install Miniconda](#install-miniconda)
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

## Cloud Infrastructure with Terraform

The GCP Cloud Infrastructure in the project was implemented using the Terraform.
The Cloud Infrastructure created by Terraform includes the following items:

- Cloud Storage bucket
- BigQuery dataset
- Artifact Registry

Terraform configuration located in the repo by the path: `eurostat-gdp/setup/terraform/`  
To get more details regarding the Terraform configuration files see [the official documentation](https://developer.hashicorp.com/terraform/language/modules/develop/structure).

The Terraform configuration in the project consists of the following files:

- **main.tf**. This file contains the main set of configuration for the project.
- **variables.tf**. This file contains the declarations for variables used in the Terraform configuration.

Let's review these files briefly. 

### main.tf

This file consists of blocks. The syntax of these blocks you can review in the [Terraform official documentation](https://developer.hashicorp.com/terraform/language/resources/syntax).
- The first block **_terraform_** contains the minimal Terraform version required and the backend to be used.
- The block **_provider_** defines the service provider and the project information.
- The block **_resource "google_storage_bucket"_** defines all required information in order to create Google Cloud storage bucket resource. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket).
- The block **_resource "google_bigquery_dataset"_** defines all required information in order to create Google BigQuery dataset resource. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset).
- The block **_resource "google_artifact_registry_repository"_** defines all required information in order to create Google Artifact registry for containers. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository).

### variables.tf

This file contains the declarations for Terraform variables. It contains blocks also. 
Each block contains the name of the variable, the type, description and a default value for the variable if required. 
In this project the values for the variables were assigned through the defalt values in this file. Meanwhile, there are [other approaches](https://developer.hashicorp.com/terraform/language/values/variables) exist.

- `variable "GCP_PROJECT_ID"`. The value for this variable is not specified. This value should be entered in the prompt field during the applying Terraform changes.
- `variable "region"`. The value for this variable specified taking into account the GCP free tier requirements.
- `variable "data_lake_bucket"`. The value for this variable specified the name of the Cloud Storage bucket that should be created.
- `variable "raw_bq_dataset"`. The value for this variable specified the name of the BigQuery dataset that should be created.
- `variable "registry_id"`. The value for this variable specified the name of the Artifact repository that should be created.

The guidance regarding the Terraform execution see in the corresponding section:  [Create GCP project infrastructure with Terraform](#create-gcp-project-infrastructure-with-terraform) 

## Orchestration

The Orchestration in the project implemented using the [Prefect](https://docs.prefect.io/latest/getting-started/quickstart/#quickstart) tool, actually [Prefect Cloud](https://docs.prefect.io/latest/cloud/) version of this tool.

## Data Ingestion and Data Lake

## Data Warehouse and Data Modeling

The project uses Google BigQuery as a Data Warehouse.   
The Data Warehouse implementation details, Data Modeling guidance and the corresponding workflow you can find [here.](./notes/dbt_notes.md)

## Data Visualization

Dashbord implementation details, the corresponding description and visualizations you can find [here.](./notes/dashboard_notes.md)

# Reproduce the project

## Set up project environment

### Prerequisites

The following items could be treated as prerequisites in order to reproduce the project:

- An active [GCP account.](https://cloud.google.com)
- It is supposed that we are going to connect to GCP VM from the local machine trough the SSH.
- (Optional) A SSH client. It is supposed that you are using a Terminal and SSH.

### Create a GCP project

- To create a new Google Cloud project go to the [GCP dashboard](https://console.cloud.google.com/) and create a new project.
- After you have created the project, you need to create a _Service Account_ in the project: 
  - ***IAM & Admin -> Service Accounts -> Create Service Account***
  - Enter the following information:
    - _***Service Account ID***_. Provide `your own value` or hit `Generate` link.
    - Grant this service account access to the project with the following roles:
      - `BigQuery Admin`
      - `BigQuery Job User`
      - `Storage Admin`
      - `Storage Object Admin`
      - `Cloud Run Admin`
      - `Service Account User`
      - `Secret Manager Admin`
      - `Viewer`
- After that create the Service Account credentials file.
  - **Service Account** -> **Manage Keys** -> **Add Key** -> **Create new key**  
  - Chose Key type: `JSON`
- Download the created Service Account credentials file to the **local machine** and store it in your home folder, i.e. in the `$HOME/.google/`.
- Create an environment variable `GOOGLE_APPLICATION_CREDENTIALS` on the **local machine** and assign to it the path to the your json Service Account credentials file
  - Open your .bashrc file: `nano .bashrc`
  - At the end of the file, add the following row: `export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.google/<your_credentials>.json"`  
  - Save you changes and close nano: `ctrl+O, ctrl+X`
  - Log out of your current terminal session and log back in, or run `source ~/.bashrc` to activate the environment variable.
- Then activate the following APIs in your GCP project:  
  - [Identity and Access Management (IAM) API](https://console.cloud.google.com/apis/library/iam.googleapis.com)
  - [IAM Service Account Credentials API](https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com)
  - [Compute Engine API](https://console.cloud.google.com/apis/library/compute.googleapis.com)
  - [Artifact Registry API](https://console.cloud.google.com/apis/library/artifactregistry.googleapis.com)
  - [Cloud Storage API](https://console.cloud.google.com/apis/library/storage.googleapis.com)
  - [BigQuery API](https://console.cloud.google.com/apis/library/bigquery.googleapis.com)
  - [Cloud Run API](https://console.cloud.google.com/apis/library/run.googleapis.com)

### Install and setup Google Cloud SDK on local machine

- Download Google Cloud SDK from [this link](https://cloud.google.com/sdk/docs/install-sdk#linux) and install it.
- Initialize the SDK following [these instructions.](https://cloud.google.com/sdk/docs/install-sdk)
  - Run `gcloud init` from a terminal and follow the instructions:
    - The system will generate a link and will ask you to go to the link in your browser.
    - When you will go to this link Google will generate the verification code in gcloud CLI on the machine you want to log into.
    - Copy this code and paste it into your terminal window prompt. 
  - Make sure that your project is selected with the command `gcloud config list`

### Install Terraform on local machine

- Terraform client installation: [https://www.terraform.io/downloads](https://www.terraform.io/downloads)  
  - `wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`
  - `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
  - `sudo apt update && sudo apt install terraform`
- Check that Terraform installed successfully. Run: `terraform -version`

### Create GCP project infrastructure with Terraform

Run the following commands:
- `cd ~/eurostat-gdp/setup/terraform`
- `terraform init`
- `terraform plan`
  - provide the value of your GCP project ID when prompted
- `terraform apply`
  - provide the value of your GCP project ID when prompted
- Go to the your GCP dashboard and make sure that the following resourses were created:
  - The Cloud Storage bucket: `eurostat_data_lake_<your_gcp_project_id>`
  - The BigQuery dataset: `eurostat_gdp_raw`

### Create a VM instance in GCP Compute Engine

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


   
### Set up SSH access to the Compute Engine VM instances on local machine

- **Create an SSH key pair on local machine.**  
  - If you connect to GCP Compute Engine virtual machine (VM) instances using third party tools or OpenSSH, you need to add a key to your VM before you can connect. If you don't have an SSH key, you must create one.
  - Create SSH key pair in accordance with the following GCP guidance: [Create SSH keys](https://cloud.google.com/compute/docs/connect/create-ssh-keys)  
    - Open a terminal window and run the following command: `ssh-keygen -t rsa -f ~/.ssh/<key_file_name> -C <user_name> -b 2048`, where:   
      - <key_file_name>: the name for your SSH key file, replace it by your own value  
      - <user_name>: your username on the VM, replace it by your own value  
    - This comand will create two files in the .ssh folder: <key_file_name> (private key) and <key_file_name>.pub (public key)
- **Upload the created ssh public key to GCP Compute Engine.**     
  - Copy the content of the <key_file_name>.pub  
  - Go to the your `GCP project console -> Compute Engine -> Settings -> Metadata -> SSH keys -> Add SSH Key`.
  - Insert the copied content of the <key_file_name>.pub -> Save.
  - All instances in this project will use this ssh key.
- **Cnfigure SSH access on the local machine.**
  - Make sure that the gcloud SDK is configured for your project:
    - Run `gcloud config list` to see your active gcp configuration details.
    - If you have multiple google accounts but the active configuration does not match the account you want - run the following command: `gcloud config configurations activate my-account`
    - If the active configuration matches your account but points to a different project - run the following command: `gcloud config set project my-project`
  - Start the created VM instance in the Google Cloud dashboard.
  - Go to the ~/.ssh folder and run `gcloud compute config-ssh`
    - This comand creates `~/.ssh/config` file for your ssh gcp connection
    - If you did not have already a SSH key, a pair of public and private SSH keys, this command will create them.
    - The output of this command will provide you the host name for the ssh connection to your instance in the format: `<instance>.<zone>.<project>`.
    - Now you should be able to open the SSH connection to your VM instance: `ssh <instance>.<zone>.<project>`
  - **You should run this command** `gcloud compute config-ssh` **each time when your VMs instances are stopped and started again** in order to update `~/.ssh/config` file and set up new value for External IP for your instance. This IP is changed every time when the instance stopped and restart again.
  - Thease are some other usefull gcloud SDK commands:
    - `gcloud compute instances list` - provides a list of your available instances
    - `gcloud compute instances start <instance_name>` - starts your instance
    - `gcloud compute instances stop <instance_name>` - stops your instance


### Set up the created VM instance in GCP

#### Start SSH connection to VM instance

- Open a terminal window on your local machine and start the VM instance using the command: `gcloud compute instances start <instance_name>`
- In order to configure the current SSH connection to the VM go to the ~/.ssh folder and run the following command: `gcloud compute config-ssh`
- Open SSH connection using the provided by the system command: `ssh <instance>.<zone>.<project>`
- Run the following command in order to keep your VM up to date : `sudo apt update && sudo apt -y upgrade`

#### Upload Google Application credentials to VM instance

- Upload the Service Account credentials file which is located on your local machine in the directory `$HOME/.google/` to the **VM instance** and store it in same folder (if such folder doesn't exist - create it beforehand.
  - The simplest way to do this is scp command. Run the following command: `scp .google/<your_credentials>.json <remoteuser>@<remotehost>:/.google`, where:  
     - <remoteuser> - user name for your VM
     - <remotehost> - it is your SSH host name `<instance>.<zone>.<project>`  
- Create an environment variable `GOOGLE_APPLICATION_CREDENTIALS` on the **VM instance** and assign to it the path to the your json Service Account credentials file - the same as have been done on the local machine:
  - Open your .bashrc file on VM instance: `nano .bashrc`
  - At the end of the file, add the following row: `export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.google/<your_credentials>.json"`
  - Save you changes and close nano: `ctrl+O, ctrl+X`
  - Activate the environment variable, run `source ~/.bashrc`.  

#### Install Docker  

- Run the following command to install docker: `sudo apt install docker.io`.
- Perform optional [post-installation procedures](https://docs.docker.com/engine/install/linux-postinstall/) to configure your Linux host machine to work with Docker without sudo command:
  - Run `sudo groupadd docker`
  - Run `sudo gpasswd -a $USER docker`
  - Re-login your SSH session
  - Run `sudo service docker restart`
  - Run `docker run hello-world` in order to check that Docker run successfully

#### Install Docker Compose

- Create a folder for binary files for your Linux user in VM:
  - Create a subfolder in your home account: `mkdir ~/bin`
  - Go to this folder: `cd ~/bin`
- Download the Docker Compose binary file:
  - `wget https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -O docker-compose`
    - it is supposed that the latest version is v2.2.3. For the other latest versions of the docker-compose-linux-x86_64 binary see the [following link](https://github.com/docker/compose/releases).
  - Make sure that the docker-compose file is in the folder
  - Make the binary file executable running the command: `chmod +x docker-compose`
- Add path to the created bin directory to the PATH environmental variable:
  - `cd`
  - `nano .bashrc`
  - Add the following line at the end of the file: `export PATH="${HOME}/bin:${PATH}"`
  - ctrl+o, ctrl+x
  - Reload the environment variables jfor the current SSH session: `source .bashrc`
  - Check Docker compose installation: `docker-compose version`



#### Clone the project repo in the VM instance

- Fork this GitHub repository in your GitHub account and clone the forked repo. It is requred because you should perform some customization changes in the code.  
- Go to the your VM instance `$HOME` directory.
- Run the following command: `git clone https://github.com/<your-git-account-name>/eurostat-gdp.git`



#### Install Miniconda

- `cd`
- Download the latest Miniconda distribution: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
- Run the installer: `bash Miniconda3-latest-Linux-x86_64.sh` and follow the instructions.
- Remove the distribution: `rm Miniconda3-latest-Linux-x86_64.sh`

#### Create an Prefect API key

In order to enable you to authenticate your local environment to work with Prefect Cloud you need to create an [API key](https://docs.prefect.io/2.13.4/cloud/users/api-keys/) in the Prefect Cloud UI first.
- Sign in into your existing Prefect Cloud account.  
- Select the account icon at the bottom-left corner of the UI.  
- Select **API Keys** -> **Create API Key +**.  
- Add a name for the key and an expiration date.  
- After you generate them, copy the key to a secure location, because that API keys cannot be revealed again in the UI.  
- In order to log into Prefect Cloud with this API Key you should run the following command: `prefect cloud login -k '<your-api-key>'`  
 

