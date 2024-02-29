# VPC

## Premium Tier

* The Network Service Tiers Premium Tier leverages Google's backbone to carry traffic to and from your external users.
* The public internet is usually only used between the user and the closest Google network ingress point.

## Standard Tier
* The Network Service Tiers Standard Tier leverages the public internet to carry traffic between your services and your users.

## VPC
* One project can contain one or more VPCs
 * There is a VPC quota limit
* VPCs are a global resource
* Subnets are regional resouces
* Subnets using the Google global network for communication within the same VPC
* A single subnet can have a primary and secondary IP range
 * There can only be one primary IP range, but up to 30 (Feb, 2024) secondary IP ranges
* Network Admin role is needed to create VPCs
* Routes for Primary/Secondary IP ranges are created automatically

## Secondary IP ranges

* If you run multiple services running on a virtual machine, you maybe want to assign different IP addresses
 * e.g. you want to run multiple web services, on port 443, every service needs it's own IP address
 * Same for containers, when every container should have it's own IP address
* GCP names them Alias IP addresses too

## GCP Reserved IPs

* Network
 * First address in the primary IP range, e.g. 192.168.0.0/24
* Gateway
 * Second address in the primary IP range, e.g. 192.168.0.1/24
* Reserved (for future use)
 * Second to last address in the primary IP range, e.g. 192.168.0.254/24
* Broadcast
 * Last address in the primary IP rande, e.g. 192.168.0.255/24
* For Secondary IP ranges just the Network IP is reserved

## Internal IP addresses

* IP addresses managed by DHCP
* IP address is from the regional subnetwork (IP range)
* DHCP renews every 24 hours
* Hostname and IP address are registered with internal DNS

## External IP addresses

* Assigned from a pool of ephemeral IPs (managed by GCP)
 * Regional External IP Pool
* DHCP renews every 24 hours
* Mapping from external IP address to internal IP address is done, without knowledge of the VM or application
* Allows communication from outside

## VPC Routes and Routing tables

* Two types of routes are supported
 * System-generated subnet routes
 * Custom routes
* GCP automatically adds routes to the PVC routing table, when a new Subnet is created
 * Primary and Secondary routes are created
* A Default route is generated too, after a VPC is created
 * Defining the path out of the VPC network
 * Standard path to Google Private Access-APIs
 * It is possible to delete the default route to isolate a resources within a VPC
 * For sure it can be replaced with a custom route, to e.g. route to a Proxy
* Custom routes can either be static routes or dynamic routes
 * Custom routes can be applied to all instances in the VPC, or only specific ones (network tags)

## VPC Firewall rules

* Rules has a priority 0 - 65535
* 0 is highest priority
* Exits on first match
* A target could be All instances, instances with specific tags, specific Service Accounts

<br/>
<br/>
<p style="text-align: center;">
<a href="./iam.md"><- back</a> | <a href="./vpc-peering-sharing.md">next -></a>
</p>