# Hybrid Connectivity

## Overview

* There are three components, when talking about Hybrid Connectivity
  * VPN
  * Interconnect
  * Cloud Router

* Colocation Facility
  * Provides Layer 2 connection between On-premises and GCP
* Metropolitan Area
  * City, where Colocation Facility is located
  * Each Metro supports a subset of regions
  * Normally you want the Colocation Facility being close to your workload (Region)
  * Otherwise you need to pay for Inter-Region Egress Traffic between your workload running in GCP and On-premise
* LOA-CFA = Letter of Authorization and Connecting Facility Assignment
  * Facility is allowed to create Crossconnect between different parties (in this case GCP equipment and our own)
* Edge Availability Domain
  * Each Colocation Facility has at least two Edge Availability Domains for redundancy
  * During planned Maintenance only one Domain will go down
* Network Service Provider
  * When using Partner Interconnect, the Colocation Facility Vendor can be a Network Service Provider too
  * It provides connectivity between on-premise network and VPC network

## Dedicated Interconnect

* Dedicated Interconnect connections are available from 153 locations
  * Start with 10Gbit/s connections
* On-premise network physically meets Google's network in a supported Colocation Facility
  * Interconnect location
  * Physical connection between our equipment and Google's Edge network equipment
  * MACsec is supported
* A 99,99% setup consists of 4 On-premise routers
  * On-Premise routers splitted to two Colocation Facilities and to different Edge Availability Domains
  * Therefore 4 Google peering edge devices
  * Two Cloud Routers in different Regions
* A 99,9% setup consists of only of two On-Premise routers
  * One Colocation Facility
  * One Cloud Router
* LOA-CFA!!!!!!!!!!!!!!!!!!!



## Partner Interconnect

* Shared connection
* Connection is done by a Service Provider
* Makes sense, when Data Center location cannot reach a Dedicated Interconnect location
* Or our traffic requirement is below the minimum of a Dedicated Interconnect
  * Minimum 10Gbit/s connection

## VPN-IPSec

* IPSec VPN connection between On-premise network and VPN gateway in GCP

## Direct Peering

* No Cost option to connect to GCP networks
  * no SLA
  * Minimum 10 Gbit/s
* Direct Peering is done in a Google Edge Network location
* Connects you with the Google Global network
  * You are not connected to your VPC
* There is no dedicated connection
  * You exchange routes with Google's edge network equipment
  * It is a Layer 3 connection

## Carrier Peering

* Shared connection
* Same like Direct Peering
* But using a shared Service Provider connection
* Can be used when traffic requirement is below 10Gbit/s
