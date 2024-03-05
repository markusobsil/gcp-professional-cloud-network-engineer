# VPC Peering

* It is possible to connect two VPCs within and across different organizations
* It is a two-way connection
 * VPC-A needs to create a Peer connection from VPC-A to VPC-B
 * VPC-B needs to create a Peer connection from VPC-B to VPC-B (accept the invitation)
* No overlapping CIDR blocks possible
 * VPC peering creation is denied if IP ranges overlap
* By default, all subnet routes are exchanged
* Project Owner, Project Editor and Network Admin roles can create a VPC network peering

## Routing between peered VPCs

* There is no route control
 * You cannot disable the (full) route exchange
 * You need to filter traffic with Firewall rules
* You can reach all internal VM IPs and Internal Load Balancer IPs after peering
* You see all subnets from the peered VPC in your routing table
 * Same Gateway IP, no difference between woen subnets and subnets of peered VPC
* Custom routes are not exchanged automatically
 * Need to be exported/imported
 * Does not matter if static or dynamic

## Example - Simple VPC peering

* [Simple VPC peering](./examples/vpc-peering-simple/main.tf) with terraform
* Created 2 VPCs in the same project
 * One VPC with 2 subnets
 * One VPC with 1 subnet and one secondary IP range
* Output shows that one VPC get all default routes including secondary IP range
 * Name of the route indicates it's origin (peering-route)

```shell
$ gcloud compute routes list --filter=network:vpc-a
NAME: default-route-300d50905a111dd6
NETWORK: vpc-a
DEST_RANGE: 10.2.0.0/16
NEXT_HOP: vpc-a
PRIORITY: 0

NAME: default-route-826a317433067d21
NETWORK: vpc-a
DEST_RANGE: 10.1.0.0/16
NEXT_HOP: vpc-a
PRIORITY: 0

NAME: default-route-f899c7d2294dac03
NETWORK: vpc-a
DEST_RANGE: 0.0.0.0/0
NEXT_HOP: default-internet-gateway
PRIORITY: 1000

NAME: peering-route-65f42c2f01d2cfb2
NETWORK: vpc-a
DEST_RANGE: 10.3.0.0/16
NEXT_HOP: peering-1-in-vpc-a
PRIORITY: 0

NAME: peering-route-a1242df1c0d88c99
NETWORK: vpc-a
DEST_RANGE: 192.168.10.0/24
NEXT_HOP: peering-1-in-vpc-a
PRIORITY: 0
```

## Example - Advertise custom static route

```
                  |----(VPC peering)----| vpc-spoke-a
                  |                       import_custom_routes=true
     vpc-hub |----|
                  |
                  |----(VPC peering)----| vpc-spoke-b
                                          import_custom_routes=false
```

* [Advertise custom route between VPCs](./examples/vpc-peering-advertise-custom-route/main.tf) with terraform
* If you have connected a on-premise location via VPN in vpc-hub, you normally create a custom route
 * Next-Hop will be the VPN tunnel endpoint
* As this is configured as custom route, it will not be exported/imported by default
* In this example I will export/import custom routes from one peering and leave the default settings on the other one

```shell
$ gcloud compute routes list --filter=network:vpc-spoke-a
NAME: default-route-9f124a6ba0c40c96
NETWORK: vpc-spoke-a
DEST_RANGE: 0.0.0.0/0
NEXT_HOP: default-internet-gateway
PRIORITY: 1000

NAME: default-route-e271d0b479397d49
NETWORK: vpc-spoke-a
DEST_RANGE: 10.2.1.0/24
NEXT_HOP: vpc-spoke-a
PRIORITY: 0

NAME: peering-route-2713a4c3b4b2c97b
NETWORK: vpc-spoke-a
DEST_RANGE: 10.1.2.0/24
NEXT_HOP: peering-vpc-hub-vpc-spoke-a
PRIORITY: 0

NAME: peering-route-88c6198e3a76d642
NETWORK: vpc-spoke-a
DEST_RANGE: 192.168.10.0/24
NEXT_HOP: peering-vpc-hub-vpc-spoke-a
PRIORITY: 0

NAME: peering-route-8e952ef8f76bbef7
NETWORK: vpc-spoke-a
DEST_RANGE: 10.1.1.0/24
NEXT_HOP: peering-vpc-hub-vpc-spoke-a
PRIORITY: 0

NAME: peering-route-bedc4bad4d5628ca
NETWORK: vpc-spoke-a
DEST_RANGE: 1.1.1.1/32
NEXT_HOP: peering-vpc-hub-vpc-spoke-a
PRIORITY: 100

NAME: peering-route-c7e4550ee4607923
NETWORK: vpc-spoke-a
DEST_RANGE: 1.1.1.2/32
NEXT_HOP: peering-vpc-hub-vpc-spoke-a
PRIORITY: 100
```

```shell
$ gcloud compute routes list --filter=network:vpc-spoke-b
NAME: default-route-a14699fe0579a396
NETWORK: vpc-spoke-b
DEST_RANGE: 10.3.1.0/24
NEXT_HOP: vpc-spoke-b
PRIORITY: 0

NAME: default-route-f94fa2af840f8914
NETWORK: vpc-spoke-b
DEST_RANGE: 0.0.0.0/0
NEXT_HOP: default-internet-gateway
PRIORITY: 1000

NAME: peering-route-0785c91139f27438
NETWORK: vpc-spoke-b
DEST_RANGE: 10.1.2.0/24
NEXT_HOP: peering-vpc-hub-vpc-spoke-b
PRIORITY: 0

NAME: peering-route-8613b0b89bb38717
NETWORK: vpc-spoke-b
DEST_RANGE: 192.168.10.0/24
NEXT_HOP: peering-vpc-hub-vpc-spoke-b
PRIORITY: 0

NAME: peering-route-f417df13ebc4fddc
NETWORK: vpc-spoke-b
DEST_RANGE: 10.1.1.0/24
NEXT_HOP: peering-vpc-hub-vpc-spoke-b
PRIORITY: 0
```

## Advantages of VPC peering

* Latency
 * Much better than using Public IP networking
* Security
 * Private communication
 * No service exposure to the public internet needed
* Costs
 * Egress bandwith pricing applies to betwork using external IPs
 * Only regular network pricing applies

<br/>
<br/>
<p style="text-align: center;">
<a href="./vpc-peering.md"><- back</a> | <a href="./vpc-sharing.md">next -></a>
</p>
