# VPC

## Premium Tier

* The Network Service Tiers Premium Tier leverages Google's backbone to carry traffic to and from your external users.
* The public internet is usually only used between the user and the closest Google network ingress point.

## Standard Tier

* The Network Service Tiers Standard Tier leverages the public internet to carry traffic between your services and your users.

## Overview

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
* There is a third route type, but a special one, which is peering
  * This will be part of the VPC peering section
* GCP automatically adds routes to the PVC routing table, when a new Subnet is created
  * Primary and Secondary routes are created
* A Default route is generated too, after a VPC is created
  * Defining the path out of the VPC network
  * Standard path to Google Private Access-APIs
  * It is possible to delete the default route to isolate a resources within a VPC
  * For sure it can be replaced with a custom route, to e.g. route to a Proxy
* Custom routes can either be static routes or dynamic routes
  * Custom routes can be applied to all instances in the VPC, or only specific ones (network tags)
* One limitations of custom static routes is, that it cannot point to a VLAN attachment

## Dynamic routes

* Normally managed by Cloud Routers
* Represent IP address ranges outside a VPC
  * Received via the GCP peer
* Use by Dedicated/Partner Interconnect, HA VPN, Classic VPN with dynamic routing

## VPC Firewall rules

* Rules has a priority 0 - 65535
* 0 is highest priority
* Exits on first match
* A target could be All instances, instances with specific tags, specific Service Accounts

## IPv6

* IPv6 is supported
  * On a subnet level
* GCP introduced the concept of a subnet stack
  * Single-stack subnets: IPv6
  * Dual-stack subnets: IPv4 and IPv6
* IPv6 access type can be *internal* or *external*
  * Internal IPv6 addresses use ULAs - Unique Local Addresses (fd20::/20)
  * External Ipv6 addresses are routable on the internet GLAs - Global Unicast Addresses (2600:1900::/28)
* The IPv6 range GCP provides can fit 68719476736 /64 networks

### ULA networks

* GCP assignes a /48 ULA range
  * from the mentioned fd20::/20 range
* Per VPC a /48
* Per Subnet a /64
* Per VM a /96

```

 +--------+----------------------------------------+----------------+--------------------------------+---------------------------------+
 |   8    |                  40                    |       16       |              32                |               32                |
 |  ULA   |                 VPC                    |     Subnet     |              VM                |             Flexible            |
 +--------+----------------------------------------+----------------+--------------------------------+---------------------------------+

 ```

### System-generated default routes in IPv6

* When a dual-stack subnets is created, a IPv6 default route is created
  * Only when an external IPv6 address range is defined
* You are able to delete the default route
  * Packets are getting dropped, if you do not replace the default route with a custom route
  * Same behaviour like in IPv4

## Bring your own IP

* BYOIP enables customers to assign IP addresses from their own public IP range to GCP resources
  * E.g. use one network of their range to route traffic to internet-facing VMs
* BYOIP is supported in GCP the same way
  * GCP manages them (you assign a IP range) and assigns them to GCP resources
  * IPs are either idle or in-use
* No charges incur for the use of the IP addresses
* The IP address is assigned to
  * Regional scope or global scope
  * Must support an external address type
  * Cannot be a Classic VPN gateway, GKE node/pod or Autoscaling MIG
* Caveats
  * Prefixes cannot overlap with subnet or alias ranges in the VPC
  * IPv4 support only
  * Overlapping BGP route announcements

## Multiple network interfaces

* One VM can have multiple network interfaces
  * To be connected to different subnets directly
  * Each subnet belongs to a different VPCs
* Every VM has a default network interface
* Caveats
  * You can only configure a network interface when you create an instance
  * The network must exist before you create the VM
  * Each network interface must be in a different network
  * The network IP ranges cannot overlap
  * Up to 8 network internfaces are supported, depending on machine type
  * General rule of thumb: one network interface per vCPU
