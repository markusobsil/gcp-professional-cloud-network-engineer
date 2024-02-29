# Identity Access Management

## Overview
* There are some roles you need to know, as a Network admin
* OrgAdmin grant/delegate the networkAdmin and securityAdmin the rights to configure network/security policies at organizational level
* They will be able to manage all projects and resources of this organization (Inheritance)
* For sure you can assign it to specific projects too

## Predefined role: Computer Network admin

* Compute Network admin: `roles/compute.networkAdmin`
* Full control of Compute Engine networking resources
* Currently about 250 permissions assigned to this role
* Cannot manage Firewall rules, certificates and IAM roles

## Predefined role: Compute Security admin

* Compute Security admin: `roles/compute.securityAdmin`
* Currently about 50 permissions assigned to this role
* Cannot manage network, but security related policies

## Predefined role: Compute Shared VPC admin

* Compute Shared VPC admin: `roles/compute.xpnAdmin`
* Creates network in the Host project and shares it with Service projects
* Needs to be assigned at organizational level, as this role manages resources above the project level
* Currently about 15 permissions assigned to this role

## Predefined role: Compute Network user

* Compute Network user: `roles/compute.networkUser`
* Service Project user who allows to consume shared VPC network

## Predefined role: Compute Network viewer

* Compute Network viewer: `roles/compute.networkViewer`
* Access network resources, but read-only
* Currently about 80 permissions are assigned to this role

## gcloud commands

### List all network related roles

```shell
gcloud iam roles list --filter="network"
```

### See details about an IAM role

```shell
gcloud iam roles describe roles/compute.networkAdmin.v1
```

