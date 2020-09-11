|
 |
 |
 |
| --- | --- | --- |

![](RackMultipart20200911-4-tmkjmz_html_db5143c38985a8e9.jpg)

![](RackMultipart20200911-4-tmkjmz_html_64ee38fdd2ba82f9.gif)

# **SAS Quickstart on azure**

![](RackMultipart20200911-4-tmkjmz_html_c24b574984a8848f.png) ![](RackMultipart20200911-4-tmkjmz_html_f06b6840b01e5058.gif) ![](RackMultipart20200911-4-tmkjmz_html_2dd50daf19499cc5.gif)

# SAS 9.4 &amp; Viya 3.5 Quick Start Deployment Guide

![](RackMultipart20200911-4-tmkjmz_html_e07c91d597232a86.gif)

August 21, 2020

Sponsored by

![](RackMultipart20200911-4-tmkjmz_html_7db9e781145fea04.png)

**Copyright @ 2020**

**All rights reserved.**

**Disclaimer**

The product/services described in this document is distributed under licenses restricting its use, copying, distribution, and decompilation/reverse engineering. No part of this document may be reproduced in any form by any means without prior written authorization of _Core Compete_ and its licensors, if any.

The services and/or databases described in this document are furnished under a license agreement or nondisclosure agreement. They may be used or copied only in accordance with the terms of the agreement.

# Table of Contents

[1. Introduction 4](#_Toc50736165)

[1.1. Objective 4](#_Toc50736166)

[1.2. Architecture Overview 4](#_Toc50736167)

[1.3. Architecture Diagram 5](#_Toc50736168)

[1.4. SAS 9 Components 6](#_Toc50736170)

[1.5. SAS Grid Components 7](#_Toc50736171)

[1.6. SAS Viya Components 7](#_Toc50736172)

[2. Costs &amp; Licenses 7](#_Toc50736173)

[2.1. SAS 9 Sizing 8](#_Toc50736174)

[2.2. SAS Grid Sizing 8](#_Toc50736175)

[2.3. SAS Viya Sizing 8](#_Toc50736176)

[3. Pre-Requisites 9](#_Toc50736177)

[3.1. Upload SAS Depot to Azure File Share 10](#_Toc50736178)

[3.2. Upload SAS 9 License File to File Share 10](#_Toc50736179)

[3.3. Upload SAS Viya License File to File Share 11](#_Toc50736180)

[4. Deployment Options 11](#_Toc50736181)

[5. Usage 15](#_Toc50736183)

[5.1. Remote Desktop Login 15](#_Toc50736184)

[5.2. Accessing SAS 9 Applications 15](#_Toc50736185)

[5.3. Accessing SAS Viya Applications 16](#_Toc50736186)

[6. Troubleshooting 16](#_Toc50736187)

[6.1. Key Directories and Locations 16](#_Toc50736188)

[6.2. Review ARM Outputs 18](#_Toc50736189)

[6.3. Review SAS 9 Services Log Files 19](#_Toc50736190)

[6.4. Review SAS Grid Services Log Files 19](#_Toc50736191)

[6.5. Review SAS Viya Service Log Files 20](#_Toc50736192)

[6.6. Restart SAS 9 Services 20](#_Toc50736193)

[6.7. Restart SAS Grid Services 20](#_Toc50736194)

[6.8. Restart SAS Viya Services 20](#_Toc50736195)

[7. Appendix 21](#_Toc50736196)

[7.1. Appendix A: Configuring Identities Service 21](#_Toc50736197)

[7.2. Appendix B: SSH Tunneling 22](#_Toc50736198)

[8. Additional Documentation 28](#_Toc50736201)

[9. Send us Feedback 29](#_Toc50736202)

[10. Acknowledgments 29](#_Toc50736203)

1.
# Introduction

This QuickStart is intended to help SAS customers deploy a cloud-native environment that provides both SAS 9.4 platform and the SAS Viya 3.5 platform in an integrated environment. It is intended to provide an easy way for customers to get a comprehensive SAS environment, that will likely result in faster migrations and deployments into the Azure environment. The SAS ecosystem is deployed on the Azure platform, leveraging Azure native deployment approaches. As part of the deployment, you get all the powerful data management, analytics, and visualization capabilities of SAS, deployed on a high-performance infrastructure.

  1.
## Objective

The SAS 9 &amp; Viya QuickStart for Azure will take a SAS provided license package for SAS 9, Viya and deploy a well-architected SAS platform into the customer&#39;s Azure subscription. The deployment creates a virtual network and other required infrastructure. After the deployment process completes, you will have the necessary details for the endpoints and connection details to log in to the new SAS Ecosystem. By default, QuickStart deployments enable Transport Layer Security (TLS) for secure communication.

Azure Resource Manager templates are included with the QuickStart to automate the following:

- Deploying SAS 9 (Non-Grid) and SAS Viya
- Deploying SAS Grid and SAS Viya

  1.
## Architecture Overview

The QuickStart will setup the following environment on Microsoft Azure:

- A Virtual Network (VNet) configured with public and private subnets. This provides the network infrastructure for your SAS 94 and SAS Viya deployments.
- In the public subnet, a Linux bastion host acting as an Ansible Controller Host.
- In the private subnet, a Remote Desktop instance acting as a Client Machine.
- In the Application subnet (private subnet), Virtual Machines for:

    - SAS 94 – Metadata, Compute and Mid-Tier
    - SAS Grid – Metadata, Grid Controller, Grid Nodes and Mid-Tier
    - SAS Viya – Microservices, SPRE, CAS Controller and CAS Workers
- Disks required for SAS Binaries, Configuration, and Data will be provisioned using Premium Disks in Azure.
- Security groups for Virtual Machines and Subnets.

  1.
## Architecture Diagram

Below are the architecture diagrams for both the deployments covered in our templates:

![](RackMultipart20200911-4-tmkjmz_html_807d640c4396c004.jpg)

_Figure 1: SAS 9 and SAS Viya Architecture Diagram_

![](RackMultipart20200911-4-tmkjmz_html_f98745fa2bb67836.jpg)

_Figure 2: SAS Grid and SAS Viya Architecture Diagram_

  1.
## SAS 9 Components

SAS 9 QuickStart bootstraps the infrastructure for a 3 machine SAS 9 environment consisting of:

- 1 x SAS Metadata Server
- 1 x SAS Compute Server
- 1 x SAS Mid-Tier Server
- 1 x Windows RDP Machine (For accessing thick clients)

It also deploys the SAS Software stack in the machines and performs post-installation steps to validate and secure the mid-tier for encrypted communication. The template will also install SAS Thick Clients like SAS Enterprise Guide, SAS Enterprise Miner, SAS Data Integration Studio, and SAS Management Console on the Windows RDP Machine.

  1.
## SAS Grid Components

Grid QuickStart bootstraps the infrastructure for a SAS Grid cluster by provisioning Azure Virtual Machines for:

- 1 x SAS Metadata Server
- 1 x SAS Grid Controller
- n x Grid Nodes (number to be specified by user while launching QuickStart)
- 1 x SAS Mid-Tier Server
- 1 x Windows RDP Machine (for accessing thick clients)

It deploys SAS Grid into this SAS Server infrastructure. The template will also install SAS Thick Clients like SAS Enterprise Guide, SAS Enterprise Miner, SAS Data Integration Studio, and SAS Management Console on the Windows RDP Machine. The template sets up the Lustre File system, which provides a shared directory for the grid. The Virtual machines provisioned for Lustre File System include:

- 1 x MGT
- 1 x MDT
- n x OSS Nodes (Number to be specified by user while launching Quick Start)

  1.
## SAS Viya Components

SAS Viya Quick Start bootstraps the infrastructure required for SAS Viya MPP system consisting of:

- 1 x Ansible Controller (acts as Bastion Host)
- 1 x Microservices
- 1 x CAS Controller
- n x CAS Worker Nodes (Number to be specified by user while launching Quick Start)

The template will run with pre-requisites to install SAS Viya on these servers and then deploy SAS Viya on the system.

1.
# Costs &amp; Licenses

The user is responsible for the cost of the Azure Cloud services used while running this QuickStart deployment. There is no additional cost for using the QuickStart. You will need a SAS license (emailed from SAS for SAS 9 and SAS Viya) to launch this QuickStart. Your SAS account team can advise on the appropriate software licensing and sizing to meet the workload and performance needs. We have given some recommended sizing for the deployment to help you choose during deployment.

  1.
## SAS 9 Sizing

Here are some recommended Machine Types for SAS 9 environment:

For **Metadata Server** , choose between 4 to 8 cores (Standard\_D4s\_v3 or Standard\_D8s\_v3) and optimum memory.

For **Compute Server** , choose from this list for:

| **Licensed Cores** | **Virtual Machine** | **Memory (RAM)** | **Temporary Storage** |
| --- | --- | --- | --- |
| **4** | Standard\_E8s\_v3 | 64 GB | 128 GB |
| **8** | Standard\_E16s\_v3 | 128 GB | 256 GB |
| **16** | Standard\_E32s\_v3 | 256 GB | 512 GB |

For the **Mid-Tier server** , choose a machine between 4 to 8 cores with sufficient memory (minimum 40 GB) to support Web Application JVMs. Choose a machine-like Standard\_DS13\_v2, Standard\_E8s\_v3, or Standard\_D8s\_v3.

  1.
## SAS Grid Sizing

You can follow the sizing recommendations from the previous section (2.1 SAS 9 Sizing) for SAS Grid deployment as well. Consider SAS Compute Servers as Grid Servers.

  1.
## SAS Viya Sizing

For SAS Viya, here are the recommendations:

**Microservices**
Choose a machine of minimum 8 cores with 60 GB memory for Microservices. Some choices are:

- Standard\_E8s\_v3 (or E16s\_v3)
- Standard\_DS13\_v2 (or DS14\_v2)

**SPRE Server**
SPRE Server is responsible for the Compute actions in the Viya environment. Choose a machine with a minimum of 8 cores. Viable choices include:

- Standard\_E8s\_v3 (or E16s\_v3/E32s\_v3)
- Standard\_D8s\_v3 (or D16s\_v3/D32s\_v3)

**CAS Controller and Workers**
Here are some recommended example VM sizes based on the number of licensed cores:

| **Licensed Cores** | **Virtual Machine** | **Memory (RAM)** | **Temporary Storage** |
| --- | --- | --- | --- |
| 4 | Standard\_E8s\_v3 | 64 GB | 128 GB |
| 8 | Standard\_E16s\_v3 | 128 GB | 256 GB |
| 16 | Standard\_E32s\_v3 | 256 GB | 512 GB |

1.
# Pre-Requisites

Before deploying SAS 9 and SAS Viya QuickStart template for Azure, you must have the following:

- An azure user account with Owner permission or Contributor and custom roles with below permissions:
  - Microsoft.Authorization/roleAssignments/write
  - \*/read
  - Microsoft.Authorization/\*/read
  - Microsoft.KeyVault/locations/\*/read
  - Microsoft.KeyVault/vaults/\*/read
- Sufficient quota for the number of Cores in Azure Account to accommodate all the servers in the SAS 9 and SAS Viya ecosystem. Please check your [subscription limits](https://docs.microsoft.com/en-us/answers/questions/10982/where-do-i-see-the-current-azure-vm-quota-limits-f.html) before launching the QuickStart. You can request an [increase](https://docs.microsoft.com/en-us/azure/azure-portal/supportability/per-vm-quota-requests) in standard vCPU quota limits per VM series from Microsoft support.
- A SAS Software Order Confirmation email that contains supported QuickStart products:
  - **SAS 9.4 Products** :
    - SAS Enterprise BI Server 9.4,
    - SAS Enterprise Miner 15.1,
    - SAS Enterprise Guide 8.2,
    - SAS Data Integration Server 9.4,
    - SAS Office Analytics 7.4
  - **SAS 9.4 Grid Products** :
    - SAS Enterprise BI Server 9.4,
    - SAS Enterprise Miner 15.1,
    - SAS Enterprise Guide 8.2,
    - SAS Data Integration Server 9.4,
    - SAS Grid Manager for Platform 9.44,
    - SAS Office Analytics 7.4,
    - Platform Suite for SAS 10.11
  - **SAS Viya 3.5 Products** :
    - SAS/ACCESS®
    - SAS/CONNECT®
    - SAS/IML®
    - SAS/QC®
    - SAS® Add-In for Microsoft Office
    - SAS® Data Preparation
    - SAS® SAS Intelligent Decisioning
    - SAS® Econometrics
    - SAS® Event Stream Processing
    - SAS® Model Manager (on SAS Viya)
    - SAS® Optimization
    - SAS® Studio
    - SAS® Visual Analytics (on SAS Viya)
    - SAS® Visual Data Mining and Machine Learning
    - SAS® Visual Forecasting
    - SAS® Visual Statistics (on SAS Viya and SAS 9.4)
    - SAS® Visual Text Analytics
    - Select SAS In-Database Technologies

- The license files (emailed from SAS for SAS 9 and SAS Viya), which contains the licensed product information, should be uploaded to the Azure File Share.

  1.
## Upload SAS Depot to Azure File Share

The QuickStart deployment requires parameters related to the license file and SAS Depot Location, which will be available once you upload the SAS Depot and License files to Azure File Share.

1. Download the SAS Depot (see SAS Email for instructions) to your system.
2. Log in to the Azure Account from which you would launch the templates.
3. Create a new Storage Account and create a new File Share with premium options. Follow the Microsoft Azure instructions to [Create a Premium File Share](https://docs.microsoft.com/en-us/azure/storage/files/storage-how-to-create-premium-fileshare?tabs=azure-portal).
4. Create new directories – &quot; **sasdepot&quot;**** &amp; &quot;viyarepo.&quot;**
5. Upload SAS 9 Depot files to Azure File Share under the **sasdepot** directory.

  1.
## Upload SAS 9 License File to File Share

Check your SAS 9 license files under the sid\_files directory in the SASDepot folder to see if the necessary SAS 9 license files are present. If not, please upload the SAS 9 License files into that directory (_e.g. \&lt;storageaccountName\&gt;/\&lt;fileshare\&gt;/\&lt;sasdepot\&gt;/sid\_files/SAS94\_xxxxxx\_xxxxxxxx\_LINUX\_X86-64.txt)_. The license file will be named like SAS94\_xxxxxx\_xxxxxxxx\_LINUX\_X86-64.txt.

  1.
## Upload SAS Viya License File to File Share

1. Download the [SAS Viya Mirror repository](https://documentation.sas.com/?docsetId=dplyml0phy0lax&amp;docsetTarget=p1ilrw734naazfn119i2rqik91r0.htm&amp;docsetVersion=3.5&amp;locale=en).
2. Login to Azure Account, upload the mirror repo to the viyarepo directory created in [_Section 3.1_](#Section3) - _step 4_.
3. Also, upload the SAS\_Viya\_deployment\_data.zip to the same directory(viyarepo).

1.
# Deployment Options

![](RackMultipart20200911-4-tmkjmz_html_deff275667aad9e.gif)
 ![](RackMultipart20200911-4-tmkjmz_html_db05be6c674cfba4.gif)

[Deploy SAS Grid and SAS Viya
](https://github.com/corecompete/sas94grid-viya/tree/develop)

[Deploy SAS 9 and SAS Viya
](https://github.com/corecompete/sas94ng-viya/tree/develop)

You can choose one of the following options to launch the template:

The deployment takes between 2 and 3 hours, depending on the quantity of software licensed and the size of machines chosen to deploy the SAS software. Below are the parameters required to fill in each of the templates:

| **SAS Parameters** | **Default** | **Description** |
| --- | --- | --- |
| Storage Account Name | _Required Input_ | The storage account name in Azure where SAS depot has been uploaded. |
| Storage Account Key | _Required Input_ | Storage Account Key for the respective Storage Account. |
| File Share Name | _Required Input_ | Name of the file share in which SAS Depot and Mirror repo have been uploaded. |
| SAS Depot Folder | _Required Input_ | Directory Name in the File Share where SAS Depot has been placed. |
| Viya Repo Folder | _Required Input_ | Directory name in the File share where Mirror Repo for SAS Viya has been placed. |
| SAS Server license file | _Required Input_ | Name of the SAS Server License file (SAS94\_xxxxxx\_xxxxxxxx\_LINUX\_X86-64.txt). Place the SAS Server License files into that directory. Make sure this file contains the licenses of all SAS94 Software Products for Linux. |
| SAS External Password | _Required Input_ | Password for all external accounts in SAS Servers for SSH and SAS applications login. |
| SAS Internal Password | _Required Input_ | This is an internal password in SAS Metadata and Web Infrastructure Platform database. The accounts with this password will have elevated privileges in the SAS estate. |
| **Infra Parameters** |
| SAS94 Data Storage – SAS Data | Default:100Min: 100
 Max:32767 | Storage Volume Size for SAS 9 Compute Server. |
| SAS Viya Data Storage | Default:100Min: 100
 Max:32767 | Storage Volume Size for SAS Viya Cas Server. |
| Admin Ingress Location | _Required Input_ | The CIDR block that can access the Ansible Controller/Bastion Host and Remote Desktop machine. We recommend that you set this value to a trusted IP range. For example, you might want to grant access only to your corporate network. |
| VNet CIDR | Default: 10.10.0.0/16 | The CIDR block for the Virtual Network. |
| Vnet Public Subnet CIDR | Default: 10.10.1.0/24 | The CIDR block for the Ansible Controller/Bastion Host Public Subnet. |
| **SAS 94 Parameters** |
| SAS94 Private Subnet CIDR | Default: 10.10.2.0/24 | The CIDR block for the first private subnet where the SAS 9 and RDP machines will be deployed. |
| SAS94 Meta VM Size | _Required Input_Default: Standard\_D4s\_v3 | VM Type for SAS Metadata Server. |
| SAS94 Mid VM Size | _Required Input_Default: Standard\_E8s\_v3 | VM Type for SAS Mid VM Server. |
| SAS94 Compute VM Size | _Required Input_Default: Standard\_E8s\_v3 | VM Type for SAS Compute Server. |
| **SAS 94 Grid Parameters** |
| SAS94 Private Subnet CIDR | Default: 10.10.2.0/24 | The CIDR block for the first private subnet where the SAS 9 and RDP machines will be deployed. |
| SAS94 Meta VM Size | _Required Input_Default: Standard\_D4s\_v3 | VM Type for SAS Metadata Server. |
| SAS94 Mid VM Size | _Required Input_Default: Standard\_E8s\_v3 | VM Type for SAS Compute Server. |
| SAS94 Grid VM Size | _Required Input_Default: Standard\_E8s\_v3 | VM Type for SAS Grid Server. |
| SAS94 Grid Node VM Size
 | _Required Input_Default: Standard\_D4s\_v3 | VM Type for SAS Grid Node Servers. |
| Number of SAS94 Grid Nodes
 | Default:1Min: 1
 Max:100 | The number of SAS Grid Node Servers. |
| Lustre Private Subnet CIDR
 | 10.10.3.0/24 | The CIDR block for the Lustre private subnet where the Lustre machines will be deployed. |
| Lustre OSS Node VM Size
 | _Required Input_Default: Standard\_E8s\_v3 | VM Type for the Lustre OSS Node Servers. |
| Number of Lustre OSS Nodes
 | Default: 1

 Min: 1
 Max:100 | The number of Lustre OSS Node Servers. |
| SAS94 Lustre Data Storage
 | Default:100Min: 100
 Max:32767 | The SAS data volume size for SAS 94 Gird. The total storage will be the multiple of OSS nodes and storage (i.e., Number of Lustre OSS Nodes \* SAS94 Lustre Data Storage). |
| **Viya Parameters** |
| Viya Private Subnet CIDR | 10.10.3.0/24 | The CIDR block for the second private subnet where the SAS Viya machines will be deployed. |
| Viya Microservices VM Size | _Required Input_
Default: Standard\_E16s\_v3 | VM Type for SAS Viya Microservices Server. |
| Viya SPRE VM Size | _Required Input_Default: Standard\_E8s\_v3 | VM Type for SAS Viya SPRE Server. |
| Viya CAS Controller VM Size | _Required Input_
Default: Standard\_E8s\_v3 | VM Type for SAS Viya CAS Controller Server. |
| Viya CAS Worker VM Size | _Required Input_Default: Standard\_E8s\_v3 | VM Type for SAS Viya CAS Worker Nodes. |
| Number of Viya CAS Nodes | _Required Input_Default: 1Min: 1
 Max: 100

 | Number of CAS Worker Nodes required for the deployment. |
| **General Parameters** |
| Subscription | _Required Input_
 | Choose the Azure Subscription from which you wish to launch the resources for the QuickStart. |
| Resource Group Name | _Required Input_ | Create New Resource Group or choose an existing Resource to launch the QuickStart resources. It is recommended to create a new resource group for each QuickStart deployment to maintain the resources. |
| Resource Group Location | _Required Input_ | Choose an appropriate location where you would like to launch your Azure resources. Please note, the Storage account with SAS Depot and Mirror Repo should exist in the same Azure region. |
| SAS Application Name | _Required Input_String Input
 No spaces
 Length – Minimum 2 &amp; Maximum 5. | Choose an Application name to the group and name your resources. We recommend using your company name or project name. This tag will be used as a prefix for the hostname of the SAS servers and Azure resources.

 |
| Key Vault Owner ID | _Required Input_ | Key Vault Owner Object ID Specifies the object ID of a user, service principal in the Azure Active Directory tenant. Obtain it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets. e.g., In Azure Cloud PowerShell type PS\&gt; Get-Az.
 It is recommended to give the used object id of whoever is deploying the QuickStart. |
| SSH Public key | _Required Input_ | The SSH public key that will be added to all the servers. |
| Location | [resourceGroup().location] | Azure Resources location, where all the SAS 94 and Viya resources should be created. e.g., servers, disks, IP&#39;s etc. The default value will pick up the same location as where the resource group is created. |
| \_artifacts Location | SAS 94 Non Grid – Viya: [https://raw.githubusercontent.com/corecompete/sas94ng-viya/master/](https://raw.githubusercontent.com/corecompete/sas94ng-viya/master/)SAS 94 Grid – Viya :
[https://raw.githubusercontent.com/corecompete/sas94grid-viya/master/](https://raw.githubusercontent.com/corecompete/sas94grid-viya/master/) | URL of the public repository where all the templates and dependant artifacts are located in. |

1.
# Usage

  1.
## Remote Desktop Login

1. SSH to the Ansible bastion host using the _ **vmuser** _.
2. Create an RDP tunnel through the bastion host. See the [_Appendix section_](#Appendix)for Tunneling instructions.
3. RDP to the Windows Server using the user(vmuser) and password (SAS External Password parameter value).

  1.
## Accessing SAS 9 Applications

The SAS 9.4 clients such as SAS Enterprise Guide, DI Studio, SAS Enterprise Miner, and SAS Management Console are installed on the Windows RDP. Log in to these applications using the _ **sasdemo** _ user. The password would be the one you specified in the template under the &quot;_ **SAS External Password parameter value** _.&quot;

  1.
## Accessing SAS Viya Applications

The SAS Viya Web applications can be accessed through the Web Brower on the RDP and directly through your browser via SSH Tunnel. See the [_Appendix section_](#Appendix)for Tunneling instructions.

1.
# Troubleshooting

  1.
## Key Directories and Locations

Below are some key locations and files which are important for troubleshooting and maintenance tasks:

**SAS 9 Environment**

| **Directory Name** | **Description/Purpose** | **Location** |
| --- | --- | --- |
| RESPONSEFILES | Location of Response files involved in SAS Deployment. | /opt/sas/resources/responsefiles |
| SASDEPLOYMENT | Location of SAS deployment.
 SAS Home and SAS Config directories reside here. | /opt/sas/ |
| SASDEPOT | Location of SAS Depot. | /sasdepot(mounted as Azure file share in all Servers) |
| SASDATA | Location of SAS data, projects, source code, and applications. | /sasdata |
| SASWORK/SASUTIL | Location of SAS workspace and temporary scratch area. This area will predominantly be used for transient and volatile data and technically emptied after the completion of job processing. | _Compute Server:_ /saswork |
| SASBACKUP | Location for SAS Backup and Recovery Tool backup vault. | /opt/sas/backups |
| DEPLOYMENTLOGS | Location for Deployment Logs. Contains the logs for all phase-wise execution of Pre-Reqs, Install, Config, and Post Deployment scripts. | /var/log/sas/install/ |

**SAS GRID Environment**

| **Directory Name** | **Description/Purpose** | **Location/Size** |
| --- | --- | --- |
| LSFINSTALL | Install Directory for LSF Components. | /opt/sas/platform |
| GRIDSHARE | Location of SAS Grid Shared Directory .  | /opt/sas/gridshare |
| SASGRIDDEPLOYMENT | Location of SAS deployment.
 SAS Home and SAS Config directories reside here. | Metadata/Mid-Tier Server:
_/opt/sas/sashome_Grid Servers:
_/opt/sas/grid_ |
| DEPLOYMENTLOGS | Location for Deployment Logs. Contains the logs for all phase-wise execution of Pre-Reqs, Install, Config, and Post Deployment scripts. | /var/logs/sas/install |

**SAS Viya Environment**

| **Directory Name** | **Description/Purpose** | **Location/Size** |
| --- | --- | --- |
| PLAYBOOKS | Location of Ansible playbooks.
The Ansible controller contains the main SAS deployment playbook, whereas the rest of the servers contain the Viya-ARK playbook required for Pre and Post Deployment tasks. | _Ansible controller:_
/sas/install/sas\_viya\_playbook_MicroServices, SPRE, CAS Servers, worker nodes:_
/opt/viya-ark |
| SASDEPLOYMENT | Location of SAS deployment. | /opt/sas |
| SASREPO | Location of a local mirror of the SAS repository (if a mirror is used). | _Visual VM:_ /sasdepot/viyarepo
(mounted shared directory on an Azure file share) |
| SASDATA | Location of SAS data, projects, source code, and applications. | _CASController VM:_
 /sasdata |
| SASWORK/SASUTIL | Location of SAS workspace and temporary scratch area. This area will predominantly be used for transient and volatile
 data and technically emptied after the completion of job processing. | _SPRE VM:_
/saswork |
| SASCACHE | Location of CAS disk cache. | _CAS Servers:_
/cascache |
| SASLOGS | Location of the SAS application log files. | /opt/sas/viya/config/var/log
 (also at /var/log/sas/viya) |
| SASBACKUP | Location for SAS Backup and Recovery Tool backup vault. | /backup |
| DEPLOYMENTLOGS | Location for Deployment Logs. Contains the logs for all phase-wise execution of Pre-Reqs, Install, Config, and Post Deployment scripts. | /var/logs/sas/install
 or
 /sas/install/sas\_viya\_playbook/deployment.log |

  1.
## Review ARM Outputs

The following outputs will be provided after the successful execution of the ARM template. Please note the output for both templates will be similar since the end-user interaction for both systems will be the same.

| **Output** | **Default** | **Description** |
| --- | --- | --- |
| Bastion Host Connection String | vmuser@x.x.x.x | Use this connection stringto connect to Bastion Host/Ansible Controller form your local machine. |
| RDP Server IP | x.x.x.x | You can use Remote Desktop Connection from your local system to this IP Address through SSH Tunneling to access the RDP server from where SAS Clients and Web Applications can be accessed. |
| SAS Metadata Connection String | _\&lt;sasmetahostname\&gt;_ 8561 | Use this connection string (Hostname and Port Number) in SAS Thick Clients like EG, DI Studio, SMC to connect to the Metadata Server. |
| SAS 9 Install User | _sasinst_ | The account is used to install and configure SAS 94 Applications. The password for this account will be the one you chose in the deployment under &quot;SAS External Password.&quot; |
| SASStudio MidTier | https://\&lt;mid-tier-hostname\&gt;:8343/SASStudio | SAS Studio URL – Web version of Enterprise Guide. |
| SAS 9 Logon | https://\&lt;mid-tier-hostname\&gt;:8343/SASLogon | SAS Application Logon URL. |
| SAS Grid Manager | https://\&lt;mid-tier-hostname\&gt;:8343/SASGridManager | SAS Grid Manager shows the |
| Viya SASStudio | https://\&lt;microservices\&gt;/SASStudioV | URL to access Viya SAS Studio. |
| SAS Viya Admin Password
 Reset URL
 | https://\&lt;microservices\&gt;/SASLogon/reset\_password?code=\&lt;token\&gt; | URL to reset the sasboot password. |
| Viya SASDrive | https://\&lt;microservices\&gt;/SASDrive | URL to access SAS Environment Manager. |

  1.
## Review SAS 9 Services Log Files

The SAS 9 Services Log files are in this parent directory: /opt/sas/config/Lev1.

The location for each SAS 9 Service can be computed from here: [https://documentation.sas.com/?docsetId=bisag&amp;docsetTarget=p1ausbmrrybuynn1xnxb6jmdfarz.htm&amp;docsetVersion=9.4&amp;locale=en](https://documentation.sas.com/?docsetId=bisag&amp;docsetTarget=p1ausbmrrybuynn1xnxb6jmdfarz.htm&amp;docsetVersion=9.4&amp;locale=en)

Refer to this SAS Note for locating SAS Log files in SAS 9.4 environment:

[https://support.sas.com/kb/55/426.html](https://support.sas.com/kb/55/426.html)

  1.
## Review SAS Grid Services Log Files

The Platform LSF and Process Manager logs can be found in the below directories:

**/opt/sas/platform/lsf/log**

**/opt/sas/platform/pm/log**

The SAS 9 Services Log files are in this parent directory: /opt/sas/config/Lev1.

The location for each SAS 9 Service can be computed from here: [https://documentation.sas.com/?docsetId=bisag&amp;docsetTarget=p1ausbmrrybuynn1xnxb6jmdfarz.htm&amp;docsetVersion=9.4&amp;locale=en](https://documentation.sas.com/?docsetId=bisag&amp;docsetTarget=p1ausbmrrybuynn1xnxb6jmdfarz.htm&amp;docsetVersion=9.4&amp;locale=en)

Refer to this SAS Note for locating SAS Log files in SAS 9.4 environment:

[https://support.sas.com/kb/55/426.html](https://support.sas.com/kb/55/426.html)

  1.
## Review SAS Viya Service Log Files

The SAS Viya log files are located under /var/log/sas/viya.

  1.
## Restart SAS 9 Services

The SAS Services on the SAS 9 environment can be restarted using the following command:

_opt/sas/config/Lev1/sas.services restart_

  1.
## Restart SAS Grid Services

The SAS Services on each server can be restarted using the following command:

_/opt/sas/config/Lev1/sas.services restart_

To restart the Platform services, run the following commands on the Grid Nodes:

_source /opt/sas/platform/lsf/conf/profile.lsf_

_source /opt/sas/platform/pm/profile.js_

_lsadmin limrestart_

_lsadmin resrestart_

_badmin hrestart_

_jadmin stop_

_jadmin start_

_gaadmin stop_

_gaadmin start_

  1.
## Restart SAS Viya Services

The SAS Services on each server can be restarted using the following command:

_systemctl sas-viya-all-services restart_

1.
# Appendix

  1.
## Appendix A: Configuring Identities Service

**Verify Security Settings**

Ensure that the correct port on your Lightweight Directory Access Protocol (LDAP) or secure LDAP (LDAPS) machine can be accessed by the SAS Viya machines:

- Port 389 if using LDAP
- Port 636 if using secure LDAP (LDAPS).

**Create a Service Account**

Create a service account in your LDAP system. The service account must have permission to read the users and groups that will log on to the system.

**Configure the Identities Service**

See [Configure the Connection to Your Identity Provider in the SAS Viya for Linux: Deployment Guide](https://documentation.sas.com/?docsetId=dplyml0phy0lax&amp;docsetTarget=p0dt267jhkqh3un178jzupyyetsa.htm&amp;docsetVersion=3.5&amp;locale=en#n1p4yydj6grbban1kl1te52gv0kf) for more information about configuring the identities service.

In the _SAS Environment Manager_, on the _Configuration_ tab, select the _Identities_ service. There are three sections to configure: connection, user, and group.

**Connection:**

**host** - the DNS address or IP address of your LDAP machine.

**password** - the password of the service account that SAS Viya will use to connect to your LDAP machine.

**port** - the port your LDAP server uses.

**userDN** - the DN of the LDAP service account.

**User:**

**accountID** - the parameter used for the username. This can be uid, samAccountName, or name depending on your system.

**baseDN** - DN to search for users under.

**Group:**

**accountID** - the parameter used for the name of the group.

**baseDN** - DN to search for groups under Set the default values to work with a standard Microsoft Active Directory system.

**Verify the Configuration**

Log in to SAS Viya with your LDAP accounts. You might need to restart SAS Viya for the LDAP changes to take effect.

Run the ldapsearch command from one of the SAS Viya machines.

_ldapsearch -x -h \&lt;YOUR LDAP HOST\&gt; -b \&lt;YOUR DN\&gt; -D \&lt;YOUR LDAP SERVICE ACCOUNT\&gt; -W_

Enter the password to your LDAP service account. If verification is successful, the list of your users and groups is displayed.

**Configure PAM for SAS Studio**

Because SAS Studio does not use the SAS Logon Manager, it has different requirements for integration with an LDAP system. SAS Studio manages authentication through a pluggable authentication module (PAM). You can use System Security Services Daemon (SSSD) to integrate the PAM configuration on your services machine with your LDAP system. To access SAS Studio, the following conditions must be met:

_The user must exist locally on the system, and the user must have an accessible home directory._

  1.
## Appendix B: SSH Tunneling

**Step 1:** In your PuTTY configuration, configure the Public IP address and Port of your Ansible-Controller/Bastion Host Server. Ansible Controller IP and user details will be available in deployment output in the Azure portal.

![](RackMultipart20200911-4-tmkjmz_html_cc01f7c6ff8f9959.png)

_Figure 3: Configure the public IP address and Port_

**Step 2:** In the _SSH_ section, browse and select the vmuser private key.

![](RackMultipart20200911-4-tmkjmz_html_2b945fa8b3fb68ea.png)

_Figure 4: Browse and select the vmuser private key_

**Step 3:** In the _SSH_ section, select the Tunnels option and configure the RDP server private IP (ARM templates outputs) with 3389 port and source port as **50001** (Random port in between 50001-60001) and click on **Add**.

![](RackMultipart20200911-4-tmkjmz_html_6f92af4dd5746985.png)

_Figure 5: Select Source Port and Destination_

**Step 4:** Make sure the entry has been correctly added, as shown below:

![](RackMultipart20200911-4-tmkjmz_html_bdcaf28a1ac18b5d.png)

_Figure 6: Check Forwarded Ports_

**Step 5:** Once all the configuration is updated, save the configuration and click on **Open.**

![](RackMultipart20200911-4-tmkjmz_html_bd03f5d600549c3e.png)

_Figure 7: Save the Configuration_

**Step 6:** Open an RDP connection and enter your local IP (127.0.0.1), along with the local port (i.e., Step3 Source Port) in PuTTY. The username will be (vmuser) and the password (SAS External Password Parameter Value).

![](RackMultipart20200911-4-tmkjmz_html_a87ea6a291754a1e.png)

_Figure 8: Open and connect an RDP connection_

1.
# Additional Documentation

QuickStart Git Repository:

[SAS 9.4 and Viya](https://github.com/corecompete/sas94ng-viya/tree/develop)

[SAS 9.4 Grid and Viya](https://github.com/corecompete/sas94grid-viya/tree/develop)

SAS 9 Documentation: [https://support.sas.com/documentation/94/](https://support.sas.com/documentation/94/)

SAS Grid Documentation: [https://support.sas.com/en/software/grid-manager-support.html](https://support.sas.com/en/software/grid-manager-support.html)

SAS Viya Documentation: [https://support.sas.com/en/software/sas-viya.html#documentation](https://support.sas.com/en/software/sas-viya.html#documentation)

Azure Well Architected Framework: [https://docs.microsoft.com/en-us/azure/architecture/framework/](https://docs.microsoft.com/en-us/azure/architecture/framework/)

1.
# Send us Feedback

Please reach out to Diane Hatcher([diane.hatcher@corecompete.com](mailto:diane.hatcher@corecompete.com)) and Rohit Shetty([rohit.shetty@corecompete.com](mailto:rohit.shetty@corecompete.com)) for any feedback or questions on the QuickStart.

1.
# Acknowledgments

We are thankful to Intel Corporation for sponsoring this development effort. We are thankful to SAS Institute for supporting this effort and including providing technical guidance and validation.
