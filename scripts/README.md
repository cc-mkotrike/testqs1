
# SAS 94 + Viya Quickstart Template for Azure

[![Deploy to Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcorecompete%2Fsas94-viya%2Fmaster%2Fazuredeploy.json) 

This README for  SAS 94 + Viya Quickstart Template for Azure is used to deploy the following SAS 94 + Viya products in the Azure cloud. Refer [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf) for detailed steps.

#### SAS 9.4
* SAS Enterprise BI Server 94
* SAS Enterprise Miner 15.1
* SAS Enterprise Guide 8.2
* SAS Data Integration Server 9.4
* SAS Office Analytics 7.4
#### SAS Viya
* SAS Visual Analytics 8.5 on Linux
* SAS Visual Statistics 8.5 on Linux
* SAS Visual Data Mining and Machine Learning 8.5 on Linux
* SAS Data Preparation 2.5

This Quickstart is a reference architecture for users who want to deploy the SAS 94 + Viya platform, using microservices and other cloud-friendly technologies. By deploying the SAS platform in Azure, you get SAS analytics, data visualization, and machine-learning capabilities in an Azure-validated environment. 


## Contents
- [SAS 94 + Viya Quickstart Template for Azure](#sas94-viya-quickstart-template-for-azure)
  - [Solution Summary](#Summary)
    - [Objective](#Objective)
    - [Architecture Overview](#Overview)
    - [Architecture Diagram](#Architecture)
    - [SAS 9 Components](#SAS9Components)
    - [SAS Viya Components](#ViyaComponents)
  - [Cost & Licenses](#Cost)
	- [SAS 9 Sizing](#SAS9Sizing)
	- [SAS Viya Sizing](#ViyaSizing)    
  - [Pre-Requisites](#prerequisites)
    - [Download SAS Software for 9.4 and Viya](#Download)
    - [Upload the SAS Software to an Azure File Share](#Upload)
  - [Best Practices When Deploying SAS Viya on Azure](#Best)
  - [Deployment Steps](#Deploy)
  - [Additional Deployment Details](#moredetails)
    - [User Accounts](#useraccounts)
    - [Important File and Folder Locations](#locations)
  - [Usage](#usage)
  - [Troubleshooting](#troubleshooting)
  - [Appendix](#appendix)
  - [Additional Documentation](#addDocs)


<a name="Summary"></a>
## Solution Summary
This QuickStart is intended to help SAS customers deploy a cloud-native environment that provides both SAS 9.4 platform and the SAS Viya 3.5 platform in an integrated environment. It is intended to provide an easy way for customers to get a comprehensive SAS environment, that will likely result in faster migrations and deployments into the Azure environment. The SAS ecosystem is deployed on the Azure platform, leveraging Azure native deployment approaches. As part of the deployment, you get all the powerful data management, analytics, and visualization capabilities of SAS, deployed on a high-performance infrastructure.

<a name="Objective"></a>
### Objective
The SAS 9 & Viya QuickStart for Azure will take a SAS provided license package for SAS 9, Viya and deploy a well-architected SAS platform into the customer’s Azure subscription. The deployment creates a virtual network and other required infrastructure. After the deployment process completes, you will have the necessary details for the endpoints and connection details to log in to the new SAS Ecosystem. By default, QuickStart deployments enable Transport Layer Security (TLS) for secure communication

<a name="Overview"></a>
### Architecture Overview
The QuickStart will setup the following environment on Microsoft Azure:
* A Virtual Network (VNet) configured with public and private subnets. This provides the network infrastructure for your SAS 94 and SAS Viya deployments.
* In the public subnet, a Linux bastion host acting as an Ansible Controller Host.
* In the private subnet, a Remote Desktop instance acting as a Client Machine.
* In the Application subnets (private subnet), Virtual Machines for:
	* SAS 94 – Metadata, Compute and Mid-Tier
	* SAS Viya – Microservices, SPRE, CAS Controller and CAS Workers
* Disks required for SAS Binaries, Configuration, and Data will be provisioned using Premium Disks in Azure.
* Security groups for Virtual Machines and Subnets.
* Accelerated Networking is enabled on all the network interfaces.
* All the servers are placed in the same proximity placement group.


<a name="Architecture"></a>
### Architecture Diagram
![Architecture Diagram](sas94-viya-architecture-diagram.svg)

<a name="SAS9Components"></a>
### SAS 9 Components
SAS 9 QuickStart bootstraps the infrastructure for a 3 machine SAS 9 environment consisting of:

 * 1 x SAS Metadata Server
 * 1 x SAS Compute Server
 * 1 x SAS Mid-Tier Server
 * 1 x Windows RDP Machine (For accessing thick clients)

It also deploys the SAS Software stack in the machines and performs post-installation steps to validate and secure the mid-tier for encrypted communication. The template will also install SAS Thick Clients like SAS Enterprise Guide, SAS Enterprise Miner, SAS Data Integration Studio, and SAS Management Console on the Windows RDP Machine.

<a name="ViyaComponents"></a>
### SAS Viya Components
SAS Viya Quick Start bootstraps the infrastructure required for SAS Viya MPP system consisting of: 

 * 1 x Ansible Controller (acts as Bastion Host)
 * 1 x Microservices
 * 1 x CAS Controller
 * n x CAS Worker Nodes (Number to be specified by user while launching Quick Start)

The template will run with pre-requisites to install SAS Viya on these servers and then deploy SAS Viya on the system.

<a name="Cost"></a>
## Cost & Licenses
The user is responsible for the cost of the Azure Cloud services used while running this QuickStart deployment. There is no additional cost for using the QuickStart. You will need a SAS license (emailed from SAS for SAS 9 and SAS Viya) to launch this QuickStart. Your SAS account team can advise on the appropriate software licensing and sizing to meet the workload and performance needs. We have given some recommended sizing for the deployment to help you choose during deployment.

<a name="SAS9Sizing"></a>
### SAS 9 Sizing
Here are some recommended Machine Types for SAS 9 environment:

For <b>Metadata Server</b>, choose between 4 to 8 cores (Standard_D4s_v3 or Standard_D8s_v3) and optimum memory. 

For Compute Server, choose from this list for:

| Licensed Cores  |	Virtual Machine  | SKU	Memory (RAM)  |	Temporary Storage |
| --------------- | ---------------- | ------------------ | ----------------- |
|   4	          |  Standard_E8s_v3 |	64 GB             |	 128 GB           | 
|   8	          |  Standard_E16s_v3 |	128 GB            |  256 GB           |
|   4	          |  Standard_E32s_v3 |	256 GB            |	 512 GB           |

For the <b>Mid-Tier server</b>, choose a machine between 4 to 8 cores with sufficient memory (minimum 40 GB) to support Web Application JVMs. Choose a machine-like Standard_DS13_v2, Standard_E8s_v3, or Standard_D8s_v3. 

<a name="ViyaSizing"></a>
### SAS Viya Sizing
For SAS Viya, here are the recommendations:

<b>Microservices Server:</b>

Choose a machine of minimum 8 cores with 60 GB memory for Microservices. Some choices are:
 * Standard_E8s_v3 (or E16s_v3)
 * Standard_DS13_v2 (or DS14_v2)

<b>SPRE Server:</b>

SPRE Server is responsible for the Compute actions in the Viya environment. Choose a machine with a minimum of 8 cores. Viable choices include:
 * Standard_E8s_v3 (or E16s_v3/E32s_v3)
 * Standard_D8s_v3 (or D16s_v3/D32s_v3)

<b>CAS Controller and Workers Nodes:</b>

Here are some recommended example VM sizes based on the number of licensed cores:
|Licensed Cores	| Virtual Machine | SKU	Memory (RAM) |	Temporary Storage |
| ------------- | --------------- | ---------------- | ------------------ |
|   4           | Standard_E8s_v3 | 64 GB	         |  128 GB            |
|   8           | Standard_E16s_v3|	128 GB           |	256 GB            |
|   16	        | Standard_E32s_v3|	256 GB	         |  512 GB            |


<a name="Prerequisites"></a>
## Prerequisites
Before deploying SAS Quickstart Template for Azure, you must have the following:

* Azure user account with Owner permission or Contributor Role and custom roles with below permissions:
    * Microsoft.Authorization/roleAssignments/write
    * */read
    * Microsoft.Authorization/*/read
    * Microsoft.KeyVault/locations/*/read
    * Microsoft.KeyVault/vaults/*/read
* Sufficient quota for the number of Cores in Azure Account to accommodate all the servers in the SAS 9 and SAS Viya ecosystem. Please check your [subscription limits](https://docs.microsoft.com/en-us/answers/questions/10982/where-do-i-see-the-current-azure-vm-quota-limits-f.html) before launching the QuickStart.  You can request an increase in standard vCPU quota limits per VM series from [Microsoft support](https://docs.microsoft.com/en-us/azure/azure-portal/supportability/per-vm-quota-requests). 
* A SAS Software Order Confirmation Email that contains supported Quickstart products.
    The license file {emailed from SAS as SAS_Viya_deployment_data.zip} which describes your SAS Software Order. SAS 9.4 software order details required to download the sasdepot.
* A resource group that does not already contain a Quickstart deployment. For more information, see [Resource groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups).
* All the Server types you select must support [Accelerated Networking](https://azure.microsoft.com/en-us/updates/accelerated-networking-in-expanded-preview/) and [Premium Storage](https://docs.microsoft.com/en-us/azure/virtual-machines/disks-types#premium-ssd)
* Refer [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf) for more information.

<a name="Download"></a>
### Download SAS Software for 9.4 and Viya

* Follow the SAS Instruction to [download the SAS 9.4 Software](https://documentation.sas.com/?docsetId=biig&docsetTarget=n03005intelplatform00install.htm&docsetVersion=9.4&locale=en)
* Follow the SAS Instruction to Create the [SAS Viya Mirror Repository](https://documentation.sas.com/?docsetId=dplyml0phy0lax&docsetTarget=p1ilrw734naazfn119i2rqik91r0.htm&docsetVersion=3.5&locale=en)
	Download SAS Mirror Manager from the [SAS Mirror Manager download site](https://support.sas.com/en/documentation/install-center/viya/deployment-tools/35/mirror-manager.html) to the machine where you want to create your mirror repository and uncompress the downloaded file.
* Run the command to Mirror the SAS viya repository:

		mirrormgr  mirror  --deployment-data  <path-to-SAS_Viya_deployment_data>.zip --path <location-of-mirror-repository> --log-file mirrormgr.log --platform 64-redhat-linux-6  --latest
 
* Refer [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf) for more information.

<a name="Upload"></a>
### Upload the SAS Software to an Azure File Share
The QuickStart deployment requires parameters related to the license file and SAS Depot Location, which will be available once you upload the SAS 9 and Viya Depot and License files to Azure File Share.

#### Creating Azure Premium FileShare
* Create Azure File Share with premium options. Follow the   Microsoft Azure instructions to "[Create a Premium File Share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-premium-fileshare?tabs=azure-portal)"
* Once the Azure Premium FileShare is created, create two new directories/folders for SAS 9 and SAS Viya - <b>"sasdepot" & "viyarepo"</b>
* Instructions to Mount FileShare on [Windows](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-windows), [Mac](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-mac) and [Linux](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux).

#### SAS Software Upload
* Once you SAS Software download is complete following the above instructions, copy/upload the complete SAS 9 Software depot to "sasdepot" directory. 
* For Viya, copy/upload the downloaded mirror to "viyarepo" folder on fileshare and also upload the <b>SAS_Viya_deployment_data.zip</b> {emailed from SAS} to same "viyarepo" folder where the viya software is located
    
#### Uploading SAS 9.4 License File
* Check your SAS 9 license files under the <b>sid_files</b> directory in the SASDepot folder to see if the necessary SAS 9 license files are present. If not, please upload the SAS 9 License files into that directory (e.g. /storageaccountName/filesharename/sasdepot/sid_files/SAS94_xxxxxx_xxxxxxxx_LINUX_X86-64.txt). The license file will be named like SAS94_xxxxxx_xxxxxxxx_LINUX_X86-64.txt.

<b>Note:</b> You might require vaules for some of the parameters that you need to provide while deploying this SAS QuickStart on Azure such as Storage Account Name, File Share Name, sasdepot folder, viyarepo folder, SAS Client license file, SAS Server license file, Storage Account Key
 
 <b>Get Storage Account Access key</b> - Follow the Microsoft Azure instructions to "[view storage account access key](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-keys-manage?tabs=azure-portal)"

* Refer [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf) for more information.
 
<a name="Best"></a>
## Best Practices When Deploying SAS Viya on Azure
We recommend the following as best practices:
* Create a separate resource group for each Quickstart deployment. For more information, see [Resource groups](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview#resource-groups).
* In resource groups that contain a Quickstart deployment, include only the Quickstart deployment in the resource group to facilitate the deletion of the deployment as a unit.

<a name="Deploy"></a>
## Deployment Steps
You can click the "Deploy to Azure" button at the beginning of this document or follow the instructions for a command-line (CLI) deployment using the scripts in the root of this repository.

The deployment takes between 1 and 2 hours, depending on the quantity of software licensed.
* Refer [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf) for more information.

<a name="moredetails"></a>
## Additional Deployment Details
<a name="useraccounts"></a>
#### User Accounts
The *vmuser* host operating system account is created during deployment. Use this account to log in via SSH to any of the machines. 

SAS External Users such sasinst is used for SAS 9.4 Installation. Create SAS Account to access the application once the deployment is finished.

SAS Users for Viya such sas and cas are created during the deployment. These are the default user accounts for logging in SAS Viya. You cannot directly log on to the host operationg system with these accounts. 

SAS Viya boot user account *sasboot* can be used to login to application. You will have the URL to reset the password of *sasboot* useraccount from the outputs section on successful deployment of the Quickstart. 

<b>Note:</b>You need to bind your servers and SAS Viya Application with an LDAP Server.

<a name="locations"></a>
#### Important File and Folder Locations
Here are some of the Key Locations and files that are useful for troubleshooting and performing any maintenance tasks:

<b>SAS 9.4 Environment</b>

|Directory Name |	Description/Purpose |	Location |
| ------------- | ---------------------------- | ------------------------- |
| RESPONSEFILES	| Location of Response files involved in SAS Deployment.  |	/opt/sas/resources/responsefiles |
| SASDEPLOYMENT	| Location of SAS deployment. SAS Home and SAS Config directories reside here. |	/opt/sas/ | 
| SASDEPOT	| Location of SAS Depot. |	/sasdepot (mounted as Azure file share in all Servers) |
| SASDATA	| Location of SAS data, projects, source code, and applications. |	/sasdata |
| SASWORK/SASUTIL |	Location of SAS workspace and temporary scratch area. This area will predominantly be used for transient and volatile data and technically emptied after the completion of job processing. |	Compute Server: /saswork |
| SASBACKUP |	Location for SAS Backup and Recovery Tool backup vault. |	/opt/sas/backups |
| DEPLOYMENTLOGS	| Location for Deployment Logs. Contains the logs for all phase-wise execution of Pre-Reqs, Install, Config, and Post Deployment scripts. |	/var/log/sas/install/ |

<b>SAS Viya Environment</b>

| Directory Name	|   Description/Purpose	          |   Location/Size           |
| -------------     | ------------------------------- | ------------------------- |
| PLAYBOOKS         |	Location of Ansible playbooks. The Ansible controller contains the main SAS deployment playbook, whereas the rest of the servers contain the Viya-ARK playbook required for Pre and Post Deployment tasks. |  <b>Ansible controller:</b> /sas/install/sas_viya_playbook <b>MicroServices, SPRE, CAS Servers, worker nodes:</b> /opt/viya-ark |
| SASDEPLOYMENT	    | Location of SAS deployment.	| /opt/sas  |
|   SASREPO	    |   Location of a local mirror of the SAS repository (if a mirror is used).	|   Visual VM: /sasdepot/viyarepo *(mounted shared directory on an Azure file share)*|
|SASDATA	    |Location of SAS data, projects, source code, and applications.	|   <b>CASController VM:</b> /sasdata |
|SASWORK/SASUTIL    |	Location of SAS workspace and temporary scratch area. This area will predominantly be used for transient and volatile data and technically emptied after the completion of job processing. | <b>SPRE VM:</b> /saswork |
| SASCACHE  |	Location of CAS disk cache. |	<b>CAS Servers:</b> /cascache |
| SASLOGS   |	Location of the SAS application log files.  |	/opt/sas/viya/config/var/log (also at /var/log/sas/viya)    |
|SASBACKUP  |	Location for SAS Backup and Recovery Tool backup vault.	    | /backup   |
|   DEPLOYMENTLOGS  |	Location for Deployment Logs. Contains the logs for all phase-wise execution of Pre-Reqs, Install, Config, and Post Deployment scripts. |	/var/logs/sas/install  <b>or</b> /sas/install/sas_viya_playbook/deployment.log |


## Usage
* Refer section 5 in [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf)
* SSH Tunneling, please refer section 7.2 in [SAS QuickStart Deployment Guide](https://github.com/corecompete/sas94-viya/blob/master/SAS-Quick-Start-on-Azure_v1.pdf)
