# Shared VPC

## Overview

* Split Projects into Host and Service projects
* Host Project has one or multiple Shared VPCs
* Service Projects granted access to use Shared VPC
* This makes it possible to have a centralized network management
  * Network Team takes care about network
  * Develop Team and their resources hosted in the Service Project
  * Separated Billing on based on project
* Any Project can can be a Host Project
* Host to Service project realationship is 1:1
  * One Service project can only be attached to one Host project

## IAM

* Organizational Admin
  * `resourcemanager.organizationAdmin` - Org. Admin role
  * Nominate Shared VPC Admins
  * Grants them appropriate Project creation/deletion roles
* Shared VPC Admin
  * Setup Shared VPC
  * Enabling Host Projects
  * Adding Service Projects to Host Projects
  * `compute.xpnAdmin` - Compute Shared VPC Admin role
  * `resourcemanager.project.IamAdmin` - Project IAM Admin role
  * Grants someone from the Service Project the Network User role
* Service Project Admin
  * Limited to whole host project or subset of Shared VPC networks
* Network Admin
  * Shared VPC Admin can delegate an IAM User the Network Admin role to have full access to the Host Project
* Security Admin
  * Same like Network Admin, but for Security related resources (certificates, firewall, etc.)
* Network User
  * IAM member who does Network tasks in the Service Project
  * Consume resources of Host project

 ```text

Org. Admin ----> Shared VPC Admin -----> Creates Host Project
                                   |---> Network Admin for Host Project
                                   |---> Security Admin for Host Project
                                   |---> Network User for the Service Project

Network Admin -----> Network Resources in Host Project

Security Admin ----> Security resources in Host Project

Network User ----> Network configuration in the Service Project

```

## Shared VPC and GCP services

* Connecting VPNs, VPC peerings, etc. to the Host projects is a best practise
  * Centralized management and sharing of those resources
* Load Balancing is different
  * Belongs to the service project, even if it has an internal IP from the Shared VPC
