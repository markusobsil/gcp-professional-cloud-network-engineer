# Cloud DNS

## Internal DNS

* Internal DNS and Cloud DNS are different offerings
* Internal DNS manages names that are automatically created by GCP for instances
  * Naming schema: `<INSTANCE-NAME>.<ZONE>.c.<PROJECT-ID>.internal`
* Internal DNS cannot be disabled

## Private Zone

* Managed by Cloud DNS
* Contains DNS records that are only visible internally
  * Need to select VPC networks, that should be able to see it
* Name server (NS) and Start of Authority (SOA) records are created automatically
  * Pointing to `ns-gcp-private.googledomains.com` by default

## Public Zone

* Managed by Cloud DNS
* Domain usally purchased (DNS registrar)
  * Visible to the internet
* DNSSEC is supported
* After creating a Public Zone, the Registrar needs to point to the Cloud DNS name servers for this Zone
  * `ns-cloud-a1.googledomains.com`
  * `ns-cloud-a2.googledomains.com`
  * `ns-cloud-a3.googledomains.com`
  * `ns-cloud-a4.googledomains.com`

### Migrating to a Cloud DNS hosted Public Zone

1. Create the Public Zone in Cloud DNS.
2. Export existing DNS records and import them in Cloud DNS (BIND and YAML format is support).
3. When importing, do not import/override the SOA record. You can use the `delete-all-existing` flag here.
4. Update the name servers at the Registrar and point to the Cloud DNS servers (mentioned above).

## Private Zone Forwarding

* There are two types of DNS Forwarding
  * Outbound DNS Forwarding: from GCP to on-premise
  * Inbound DNS Forwarding: from on-premise to GCP
* Keep in mind, when you enable DNS forwarding, you are using Google's DNS proxies. Those live in the 35.199.192.0/19 network.
  * This range is owned by GCP and is not advertised to the internet
* If you have the requirement, that your VMs need to resolve records from a Private DNS Zone, which lives on-premise, you can use Outbound forwarding
  * Think of running the web servers as VMs in GCP, but having the rest of the infrastructure on-premise, like database servers
  * The outbound forwarding is configured as a Private Zone in Cloud DNS with an Destination DNS server that lives on-premise (option `Forward queries to another server`)
  * Consider, that you need to configure on-premise routes/firewalls to allow Google IP address range 35.199.192.0/19
* Inbound forwarding is the other way around
  * Cloud DNS hosts a Private Zone, that needs to be accessible by on-premise infrastructure
  * A private Zone is normally only visible in the selected VPC networks
  * You need to create a DNS inbound server policy to modify the behavior of Cloud DNS
  * `Inbound query forwarding` needs to be activated
  * The on-premise devices can then resolve records according to a VPC network's name resolution order

## DNS Peering

* DNS peering is another way to extend the reachability of Private Zones
  * Send queries to other VPC networks for resolution
* When creating a private Zone
  * Select the option `DNS Peering`
  * Specify the Peer project and the peer network
  * Cloud DNS takes care about the peering connection between your and the other VPC

```text
+-------------------------+                 +------------------------+
| VPC Consumer            |                 | VPC Producer           |
| +---------------------+ |                 | +--------------------+ |
| |  Private Zone       | |                 | |  Private Zone      | |
| |  private.local      | |                 | |  private.local     | |
| |                     | |                 | |                    | |
| |  +---------------+  | |                 | |                    | |
| |  |  DNS Peering  |----------------------->|                    | |
| |  +---------------+  | |                 | |                    | |
| +---------------------+ |                 | +--------------------+ |
+-------------------------+                 +------------------------+
```

### Multi-VPC peering

* DNS peering is possible with multiple Consumer VPCs too
* Benefit here is to have a single point of configuration
  * In a different VPC, in a different Project, maintained by a different team

## Response Policies

* Next to the DNS server policies, there are response policies
* Response policies are again a feature for private Zones
* It contains rules
  * Those rules are getting consulted during lookups
  * This means, a response could be different to different DNS clients
  * Concept of a DNS firewall

## Routing Policies

* There are types of DNS routing policies
  * Weighted round robin: Specify different weights per DNS target
  * Geolocation: Map traffic to specific DNS targets based on origin
  * Failover: Active/Backup setup
* Routing Policies can be used for external and internal traffic
* Caveats
  * Nesting or combining routing policies is not possible
  * Only on type of routing policy can be applied to a resource record set at a time

## DNS Security

* Public Zones support DNSSEC
  * Used to authenticate (digitally sign) responses to domain name lookups
  * Cloud DNS serve special DNSSEC records
  * `DNSKEY` and `RRSIG`
* When enabling DNSSEC for a Public Zone
  * Cloud DNS automatically creates and rotates DNSSEC keys, `DNSKEY` records
  * And signing of Zone data with resource digital signature (RRSIG) records
* The registrar need to have a DS (Delegation Signer) records, that authenticates a DNSKEY record in your Zone
  * This build the root of your chain of trust for your domain
* Either the clients itself or a resolver needs to validate the signatures
* For migration purposes you can use the DNSSEC Transfer mode of the Public Zone
  * Transfer mode stops key rotation and allows the DNSKEY import
  * This is needed when migration a DNSSEC enabled Zone to/from Cloud DNS
  * In those cases you cannot create a new DNSKEY
  * Furthermore algorithms must match to make this possible
