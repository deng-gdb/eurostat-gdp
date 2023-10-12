# Index

- [Dataset](#dataset)
- [Technologies and Tools](#technologies-and-tools)
- [Data Pipeline Architecture and Workflow](#data-pipeline-architecture-and-workflow)
  - [Local Machine](#local-machine)
  - [Prefect execution environment: Docker, Google Artifact Registry, Google Cloud Run](#prefect-execution-environment-docker-google-artifact-registry-google-cloud-run)
  - [Prefect Agent and GCP VM instance](#prefect-agent-and-gcp-vm-instance)
  - [Cloud Infrastructure with Terraform](#cloud-infrastructure-with-terraform) 
  - [Orchestration](#orchestration)
  - [Data Ingestion and Data Lake](#data-ingestion-and-data-lake)
  - [Data Warehouse and Data Modeling](#data-warehouse-and-data-modeling)
  - [Data Visualization](#data-visualization)
- [Reproduce the project](#reproduce-the-project)
  - [Set up project environment](#set-up-project-environment)
    - [Prerequisites](#prerequisites)
    - [Create a GCP project](#create-a-gcp-project)
    - [Create a Prefect Cloud Account and Workspace](#create-a-prefect-cloud-account-and-workspace)
      - [Create an Prefect Cloud API key](#create-an-prefect-cloud-api-key)  
    - [Setup local development environment](#setup-local-development-environment)
      - [Install and setup Google Cloud SDK on local machine](#install-and-setup-google-cloud-sdk-on-local-machine)
      - [Clone the project repo on local machine](#clone-the-project-repo-on-local-machine)
      - [Install Terraform on local machine](#install-terraform-on-local-machine)
      - [Install Prefect on local machine](#install-prefect-on-local-machine)
      - [Install Docker on local machine](#install-docker-on-local-machine)
      - [Set up SSH access to the Compute Engine VM instances on local machine](#set-up-ssh-access-to-the-compute-engine-vm-instances-on-local-machine)
    - [Create GCP project infrastructure with Terraform](#create-gcp-project-infrastructure-with-terraform) 
    - [Setup cloud execution environment](#setup-cloud-execution-environment)      
      - [Create Prefect Cloud Blocks](#create-prefect-cloud-blocks)
      - [Build a Docker image and place it to the Artifact Registry](#build-a-docker-image-and-place-it-to-the-artifact-registry)      
    - [Create a VM instance in GCP Compute Engine](#create-a-vm-instance-in-gcp-compute-engine)
    
    
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


## Local Machine

In the project architecture a local machine is used for development purpose and for ssh communication with GCP Compute Engine VM instance.

So, on the local machine the following software should be installed:
- Python
- Google Cloud SDK
- Git
- Terraform 
- Prefect
- Docker

The details see in the section [Setup local development environment](#setup-local-development-environment).


## Prefect execution environment: Docker, Google Artifact Registry, Google Cloud Run

To run Prefect workflows scripts in the Cloud an execution environment is required. 
In the project such execution environment consists of two parts: **Docker image** which is stored in the **Google Artifact Registry** and **Google Cloud Run**.
- Docker image contains the base environment for execution: Python, Prefect and all required dependencies that should be installed in the base environment in the Docker image. 
- [GCP Artifact Registry.](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images#auth) is used to store the Docker image. 
- [Google Cloud Run](https://cloud.google.com/run/?hl=en) is used to run the corresponding Docker container.

**Be aware of the following**_:  
  - The Docker image contains _**only base environment for Prefect execution**_: Python, Prefect, etc.
  - The Prefect _**flows scripts**_ itself are located in the corresponding _**GitHub repository**_.
  - The code requred to build the Docker image is located in the `setup/docker` folder in the project repo.
  - All environment dependencies are captured in the `setup/docker/docker-requirements.txt` file and will be installed in the base environment in the Docker image.


## Prefect Agent and GCP VM instance

The [Prefect agent](https://docs.prefect.io/2.13.5/concepts/agents/) is a lightweight polling service that periodically check scheduled flow runs from a Prefect Server work pool (located in the Prefect Cloud) and execute the corresponding Prefect flow runs. Agents poll for work every 15 seconds by default. 

In the project architecture the Prefect agent is running on a Google Compute Engine VM instance. 
- The creation of this part of the architecture completly implemented using Terraform (see the corresponding section [Cloud Infrastructure with Terraform](#cloud-infrastructure-with-terraform)
- The code that _**creates the VM instance**_ is located in the `setup/terraform/main.tf` file in the section `resource "google_compute_instance"`.
- The script that _**installs the Python and Prefect Agent**_ on the created VM instance and _**connects it to the Prefect Cloud**_ with Prefect API key is located in the `setup/terraform/scripts/install.sh` file.
- The code that runs the mentioned script `setup/terraform/scripts/install.sh` is located in the `setup/terraform/main.tf` file in the section `provisioner "remote-exec"`.


## Cloud Infrastructure with Terraform

The GCP Cloud Infrastructure in the project was implemented using the Terraform.
The Cloud Infrastructure created by Terraform includes the following items:

- Cloud Storage bucket
- BigQuery dataset
- Virtual Machine instance
- Artifact Registry

Terraform configuration located in the repo by the path: `eurostat-gdp/setup/terraform/`  
To get more details regarding the Terraform configuration files see [the official documentation](https://developer.hashicorp.com/terraform/language/modules/develop/structure).

The Terraform configuration in the project consists of the following files:

- **main.tf**. This file contains the main set of configuration for the project.
- **variables.tf**. This file contains the declarations for variables used in the Terraform configuration.
- **terraform.tfvars**. This file specifies the values for the Terraform variables from the file `variables.tf` which contain private information and should be provided during project setup individually.

Let's review these files briefly. 

### main.tf

This file consists of blocks. The syntax of these blocks you can review in the [Terraform official documentation](https://developer.hashicorp.com/terraform/language/resources/syntax).
- The first block **_terraform_** contains the minimal Terraform version required and the backend to be used.
- The block **_provider_** defines the service provider and the project information.
- The block **_resource "google_storage_bucket"_** defines all required information in order to create Google Cloud storage bucket resource. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket).
- The block **_resource "google_bigquery_dataset"_** defines all required information in order to create Google BigQuery dataset resource. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset).
- The block **_resource "google_artifact_registry_repository"_** defines all required information in order to create Google Artifact registry for containers. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository).
- The block **_resource "google_compute_instance"_** defines all required information in order to create a Google VM instance resource within Compute Emgine. The structure of this block you can find in the official documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance).
  - The values for this block were provided in accordance with with the GCP Free Tier limitations
  - The value for the argument `image` you can find using the following command, f.e. : `gcloud compute images list | grep ubuntu`
  - Some considerations regarding the Servive Account for the VM instance you can find in the [official documentation](https://cloud.google.com/compute/docs/access/service-accounts#default_service_account).
  - Be aware, that after the creation Terraform starts the created VM. So, if you are not going to work further now - don't forget to stop the VM to avoid unnecessary fees.


### variables.tf

This file contains the declarations for Terraform variables. It contains blocks also. 
Each block contains the name of the variable, the type, description and a default value for the variable if required. 
In this project the values for the variables were assigned through the defalt values in this file. Meanwhile, there are [other approaches](https://developer.hashicorp.com/terraform/language/values/variables) exist.

- `variable "gcp_project_id"`. Your own GCP Project ID. The value for this variable is not specified. This value should be entered in the file `terraform.tfvars`.
- `variable "ce_service_account_email"`. This is email identifier for your default Service Accaount, which is used by the Compute Engine service. The value for this variable is not specified. This value should be entered in the file `terraform.tfvars`. 
- `variable "region"`. The value for this variable specified taking into account the GCP free tier requirements.
- `variable "data_lake_bucket"`. The value for this variable specified the name of the Cloud Storage bucket that should be created.
- `variable "raw_bq_dataset"`. The value for this variable specified the name of the BigQuery dataset that should be created.
  - Be aware that this value must be alphanumeric (plus underscores). 
- `variable "registry_id"`. The value for this variable specified the name of the Artifact repository that should be created.  
  - Be aware that this value may only contain lowercase letters, numbers, and hyphens, and must begin with a letter and end with a letter or number.
  - `variable "vm_script_path"`. This variable contains the path to the script which install the required packages on the VM and which should be run on the Virtual Machine compute instance just after of its creation by Terraform.
  - `variable "ssh_user_name"`. This variable contains the name of the user that will be used to remote exec the script specified in the variable `vm_script_path` trough ssh.
  - `variable "ssh_private_key_path"`. This variable contains the path to the private ssh key which is used to connect to the VM instance.


### terraform.tfvars

This file specifies the values for the variables from the file `variables.tf` which contain private information and should be provided during project setup individually.

- `gcp_project_id`.  You can find this value on the your GCP Project Dashboard.
- `ce_service_account_email`. This value you can find in your GCP console: IAM & Admin -> Service Accounts. Find the account with the name "Compute Engine default service account" and take its email.
- `ssh_user_name`.  Insert your own value here.
- `ssh_private_key_path`. Insert the value, which your provided when you created the SSH key pair on your local machine.

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
      - `Editor`
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


### Create a Prefect Cloud Account and Workspace

- [Sign in or register](https://docs.prefect.io/2.13.5/cloud/cloud-quickstart/#sign-in-or-register) a Prefect Cloud account.
- [Create a workspace](https://docs.prefect.io/2.13.5/cloud/cloud-quickstart/#create-a-workspace) for your account.
- Create an Prefect API key. In order to enable you to authenticate your local (and other) environment to work with Prefect Cloud you need to create an [API key](https://docs.prefect.io/2.13.4/cloud/users/api-keys/) in the Prefect Cloud UI first. See the next section.


#### Create an Prefect Cloud API key

- Sign in into your existing Prefect Cloud account.  
- Select the account icon at the bottom-left corner of the UI.  
- Select **API Keys** -> **Create API Key +**.  
- Add a name for the key and an expiration date.  
- After you generate them, copy the key to a secure location, because that API keys cannot be revealed again in the UI.  
- In order to log into Prefect Cloud with this API Key you should run the following command: `prefect cloud login -k '<your-api-key>'` 


### Setup local development environment


#### Install and setup Google Cloud SDK on local machine

- Download Google Cloud SDK from [this link](https://cloud.google.com/sdk/docs/install-sdk#linux) and install it.
- Initialize the SDK following [these instructions.](https://cloud.google.com/sdk/docs/install-sdk)
  - Run `gcloud init` from a terminal and follow the instructions:
    - The system will generate a link and will ask you to go to the link in your browser.
    - When you will go to this link Google will generate the verification code in gcloud CLI on the machine you want to log into.
    - Copy this code and paste it into your terminal window prompt. 
  - Make sure that your project is selected with the command `gcloud config list`


#### Clone the project repo on local machine

- Fork this GitHub repository in your GitHub account and clone the forked repo. It is requred because you should perform some customization changes in the code.  
- Go to the your `$HOME` directory.
- Run the following command: `git clone https://github.com/<your-git-account-name>/eurostat-gdp.git`


#### Install Terraform on local machine

- Terraform client installation: [https://www.terraform.io/downloads](https://www.terraform.io/downloads)  
  - `wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`
  - `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
  - `sudo apt update && sudo apt install terraform`
- Check that Terraform installed successfully. Run: `terraform -version`


#### Install Prefect on local machine

- Install Prefect and Prefect GCP module on your local environment:  
  - `pip install -U prefect`
  - `pip install 'prefect_gcp[cloud_storage]'`
- Create an Prefect API key  
  In order to enable you to authenticate your local environment to work with Prefect Cloud you need to create an [API key](https://docs.prefect.io/2.13.4/cloud/users/api-keys/) in the Prefect Cloud UI first.
  - Sign in into your existing Prefect Cloud account.  
  - Select the account icon at the bottom-left corner of the UI.  
  - Select **API Keys** -> **Create API Key +**.  
  - Add a name for the key and an expiration date.  
  - After you generate them, copy the key to a secure location, because that API keys cannot be revealed again in the UI.  
- Login to Prefect Cloud with this API Key
  - Run the following command: `prefect cloud login -k '<your-api-key>'`  

  
#### Set up SSH access to the Compute Engine VM instances on local machine

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


### Create GCP project infrastructure with Terraform

Run the following commands:
- `cd ~/eurostat-gdp/setup/terraform`
- edit a file `terraform.tfvars` - insert your own values for the variables here.
- edit a file `scripts/instal.sh` - insert your own value for the statement `prefect cloud login -k ...`
- `terraform init`
- `terraform plan`
- `terraform apply`
- Go to the your GCP dashboard and make sure that the following resourses were created:
  - [Cloud Storage bucket](https://console.cloud.google.com/storage): `eurostat_gdp_data_lake_<your_gcp_project_id>`
  - [BigQuery dataset](https://console.cloud.google.com/bigquery): `eurostat_gdp_raw`
  - [VM instances](https://console.cloud.google.com/compute/instances): `eurostat-gdp-vm-instance`
  - [Artifact Registry](https://console.cloud.google.com/artifacts): `eurostat-gdp-repository`

### Setup cloud execution environment

#### Create Prefect Cloud Blocks

- Go to the project repo folder _**eurostat-gdp/setup**_. The project repo have already been cloned on local machine on the previous steps.
- Open the file _**setup.py**_ and enter your own values for all variables.
- Run the command: `python create_blocks.py`
- Open your Prefect Cloud account, go to the _**Blocks**_ tab and check, that the following blocks were created:
  - GCP Credentials block with the name: eurostat-gdp-gcp-creds
  - GCS Bucket block with the name: eurostat-gdp-gcs-bucket
  - GitHub block with the name: eurostat-gdp-github

Create block GCP Cloud Run Job. It is an infrastructure block used to run GCP Cloud Run Jobs. Because this block is experimental and the interface may change without notice, we create this block mannually through Prefect Cloud UI.
- Open your Prefect Cloud account, go to the _**Blocks**_ tab and create new _**GCP Cloud Run Job**_ block
- Enter the following information:
  - Block name: `eurostat-gdp-cloud-run`
  - Type: `cloud-run-job`
  - Image Name: `us-east1-docker.pkg.dev/<your-gcp-project-id>/eurostat-gdp-repository/eurostat-gdp:v1`
  - Region: `us-east1`
  - GcpCredentials: `eurostat-gdp-gcp-creds`
- Save the changes

#### Build a Docker image and place it to the Artifact Registry

_
_**Make the following steps**_:
- Run Docker Desctop
- [Configure Docker to use the Google Cloud CLI to authenticate requests to Artifact Registry](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images#auth).
  - To set up authentication to Docker repositories in the region us-east1, run the following command: `gcloud auth configure-docker us-east1-docker.pkg.dev`
- Build the Docker image: `docker build -t eurostat-gdp:v1 .`
- Before you push the Docker image to Artifact Registry, you must [tag it with the repository name](https://cloud.google.com/artifact-registry/docs/docker/store-docker-container-images#tag). Run the following command:  
  - `docker tag eurostat-gdp:v1 us-east1-docker.pkg.dev/<gcp_project_id>/eurostat-gdp-repository/eurostat-gdp:v1` , where:
    - us-east1-docker.pkg.dev - is the hostname for the Docker repository you created.
    - **<gcp_project_id>** - is your Google Cloud project ID. You should enter your value here.
    - eurostat-gdp-repository - is the name of the repository you created
    - eurostat-gdp:v1 - is the image name you want to use in the repository. 
- Push the Docker image to the registry: `docker push us-east1-docker.pkg.dev/free-tier-project-397608/eurostat-gdp-repository/eurostat-gdp:v1`
- Open your [Artifact Registry](https://console.cloud.google.com/artifacts) and check that the Docker image exists in the repository.




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

 
 

