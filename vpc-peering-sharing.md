# VPC Peering and Shared VPC

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

## Example - On-Premise networks

* If you have connected a on-premise location via VPN in VPC-A, you normally create a custom route
 * Next-Hop will be the VPN tunnel endpoint
* As this is configured as custom route, it will not be exchanged with VPC-B by default
* You would need to export this custom route and import it in VPC-B
* Let's assume VPC-A is peered with VPC-B and VPC-C
 * VPC-B and VPC-C cannot communicate with each other, as there is not transitive peering supported
* If you export/import the On-Premise network, you build sort of a Hub-Spoke topology


```
                                            |----(VPC peering)----> VPC-B
                                            |                       (Spoke)
On-Premise network ----(VPN)----> VPC-A ----|
                                  (Hub)     |
                                            |----(VPC peering)----> VPC-C
                                                                    (Spoke)
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
<a href="./vpc-peering-sharing.md"><- back</a> | <a href="./README.md">next -></a>
</p>