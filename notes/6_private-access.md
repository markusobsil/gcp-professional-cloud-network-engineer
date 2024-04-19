# Google Private Access

## Overview

* GCE or on-premise need access to Google APIs
  * Without a Public IP
* The VPC default internet gateway takes care about that
* Google Private access needs to be enabled in the subnet basis
* Google Private access has no effect on instances with external IP addresses
* Furthermore a Firewall rule to allow outgoing traffic to 0.0.0.0/0 is needed to allow the access of the APIs
  * Use network tags to allow only instances that really need Google API access and block outgoing traffic from all other instances
* Google APIs are using `googleapis.com` as the base domain
* Stackdriver logs all API requests by IP
  * This help in case of troubleshooting

## Details

* `restricted.googleapis.com` - 199.36.153.4/30
  * Used for servies that are supported by VPC Service Controls
  * Blocks access to services that do not support VPC service controls
* `private.googleapis.com` - 199.36.153.8/30
  * Used for the most services (except Workspace web or interactive websites)
  * Does not care about VPC service controls
* When enabling Google private access on a subnet, you can reach Google APIs via the mentioned VIPs
  * This is baked in the Internet Gateway
* If you have a customized default route, or you want to configure it on your own
  * Configure routes for the VIPs of restricted or private APIs
  * Configure DNS records for the Google APIs
* This is all the magic this feature is doing
