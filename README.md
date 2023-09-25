# Index

- [Dataset](#dataset)
- [Technologies and Tools](#technologies-and-tools)
- [Data Pipeline Architecture and Workflow](#data-pipeline-architecture-and-workflow)
  - [Data Ingestion, Orchestration and Data Lake](#data-ingestion-orchestration-and-data-lake)
  - [Data Warehouse and Data Modeling](#data-warehouse-and-data-modeling)
  - [Data Visualization](#data-visualization)
- [Reproduce the project](#reproduce-the-project)
  - [Set up project environment](#set-up-project-environment)
    - [Prerequisites](#prerequisites)
    - [Create a GCP project](#create-a-gcp-project)
    - [Create a VM instance in GCP Compute Engine](#create-a-vm-instance-in-gcp-compute-engine)
    - [Install and setup Google Cloud SDK on local machine](#install-and-setup-google-cloud-sdk-on-local-machine)
    - [Set up SSH access to the Compute Engine VM instances on local machine](#set-up-ssh-access-to-the-compute-engine-vm-instances-on-local-machine)
    - [Set up the created VM instance in GCP](#set-up-the-created-vm-instance-in-gcp)
      - [Start SSH connection to VM instance](#start-ssh-connection-to-vm-instance)
      - [Upload Google Application credentials to VM instance](#upload-google-application-credentials-to-vm-instance)
      - [Install Docker](#install-docker)
      - [Install Docker Compose](#install-docker-compose)
      - [Install Terraform](#install-terraform)
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

## Data Ingestion, Orchestration and Data Lake

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
      - `Storage Admin`
      - `Storage Object Admin`
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
  - https://console.cloud.google.com/apis/library/iam.googleapis.com
  - https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com

### Create and setup a VM instance in GCP Compute Engine

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

### Install and setup Google Cloud SDK on local machine

- Download Google Cloud SDK from [this link](https://cloud.google.com/sdk/docs/install-sdk#linux) and install it.
- Initialize the SDK following [these instructions.](https://cloud.google.com/sdk/docs/install-sdk)
  - Run `gcloud init` from a terminal and follow the instructions:
    - The system will generate a link and will ask you to go to the link in your browser.
    - When you will go to this link Google will generate the verification code in gcloud CLI on the machine you want to log into.
    - Copy this code and paste it into your terminal window prompt. 
  - Make sure that your project is selected with the command `gcloud config list`
   
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

#### Install Terraform

- Terraform client installation: [https://www.terraform.io/downloads](https://www.terraform.io/downloads)  
  - `wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`
  - `echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`
  - `sudo apt update && sudo apt install terraform`
   

#### Install Miniconda

- `cd`
- Download the latest Miniconda distribution: `wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh`
- Run the installer: `bash Miniconda3-latest-Linux-x86_64.sh` and follow the instructions.
- Remove the distribution: `rm Miniconda3-latest-Linux-x86_64.sh`
