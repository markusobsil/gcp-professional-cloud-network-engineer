# vpc-hub
resource "google_compute_network" "vpc-hub" {
  name                    = "vpc-hub"
  auto_create_subnetworks = "false"
}

# vpc-spoke-a
resource "google_compute_network" "vpc-spoke-a" {
  name                    = "vpc-spoke-a"
  auto_create_subnetworks = "false"
}

# vpc-spoke-b
resource "google_compute_network" "vpc-spoke-b" {
  name                    = "vpc-spoke-b"
  auto_create_subnetworks = "false"
}

# Subnet 1 in vpc-hub
resource "google_compute_subnetwork" "subnet-1-in-vpc-hub" {
  name          = "subnet-1-in-vpc-hub"
  ip_cidr_range = "10.1.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc-hub.id
}

# Subnet 2 in vpc-hub
resource "google_compute_subnetwork" "subnet-2-in-vpc-hub" {
  name          = "subnet-2-in-vpc-hub"
  ip_cidr_range = "10.1.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc-hub.id
  secondary_ip_range {
    range_name    = "subnet-1-in-vpc-b-secondary"
    ip_cidr_range = "192.168.10.0/24"
  }
}

# Subnet 1 in vpc-spoke-a
resource "google_compute_subnetwork" "subnet-1-in-vpc-spoke-a" {
  name          = "subnet-1-in-vpc-spoke-a"
  ip_cidr_range = "10.2.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc-spoke-a.id
}

# Subnet 1 in vpc-spoke-b
resource "google_compute_subnetwork" "subnet-1-in-vpc-spoke-b" {
  name          = "subnet-1-in-vpc-spoke-b"
  ip_cidr_range = "10.3.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc-spoke-b.id
}

# Static route 1 in vpc-hub
resource "google_compute_route" "static-route-1-vpc-hub" {
  name        = "static-route-1-vpc-hub"
  dest_range  = "1.1.1.1/32"
  network     = google_compute_network.vpc-hub.id
  next_hop_ip = "10.1.1.1"
  priority    = 100
}

# Static route 2 in vpc-hub
resource "google_compute_route" "static-route-2-vpc-hub" {
  name        = "static-route-2-vpc-hub"
  dest_range  = "1.1.1.2/32"
  network     = google_compute_network.vpc-hub.id
  next_hop_ip = "10.1.1.2"
  priority    = 100
}

# VPC Peering vpc-hub <> vpc-spoke-a
resource "google_compute_network_peering" "peering-vpc-hub-vpc-spoke-a" {
  name                 = "peering-vpc-hub-vpc-spoke-a"
  network              = google_compute_network.vpc-hub.self_link
  peer_network         = google_compute_network.vpc-spoke-a.self_link
  export_custom_routes = true
}

resource "google_compute_network_peering" "peering-vpc-spoke-a-vpc-hub" {
  name                 = "peering-vpc-hub-vpc-spoke-a"
  network              = google_compute_network.vpc-spoke-a.self_link
  peer_network         = google_compute_network.vpc-hub.self_link
  import_custom_routes = true
}

# VPC Peering vpc-hub <> vpc-spoke-b
resource "google_compute_network_peering" "peering-vpc-hub-vpc-spoke-b" {
  name         = "peering-vpc-hub-vpc-spoke-b"
  network      = google_compute_network.vpc-hub.self_link
  peer_network = google_compute_network.vpc-spoke-b.self_link
}

resource "google_compute_network_peering" "peering-vpc-spoke-b-vpc-hub" {
  name         = "peering-vpc-hub-vpc-spoke-b"
  network      = google_compute_network.vpc-spoke-b.self_link
  peer_network = google_compute_network.vpc-hub.self_link
}
