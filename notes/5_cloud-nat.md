# Cloud NAT

## Overview

* Provide outgoing connections for instances without public IP address
* Cloud NAT is a managed services (HA)
  * High Availability
  * Scalability - scales with the number of instances/traffic
  * Represented as a Cloud Router
* Cloud NAT is a regional service and VPC specific
  * Source can be Primaryand Secondary ranges for all subnets
  * Source can be Primary ranges for all subnets
  * Source can be Custom = selected subnets only
* External (NAT) IP can be slected manually or assigned automatically
* Instances with Public IPs will not use the NAT gateway
  * Even if their Subnetwork is configured as Source
* Each instance is assigned a unique set of NAT IPs and associated port ranges
  * Can be configured (number of ports per instance)
  * This is assinged per VM instance
  * Keep this in mind when working with secondary IP ranges
* NAT gateway supports Public and Private NAT

## Architecture

* [Cloud NAT](https://cloud.google.com/nat/docs/overview#architecture)
* Software-defined managed service
* There is no intermediate proxy instance/appliance
* Cloud NAT configures Andromeda itself
