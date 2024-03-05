# vpc-a
resource "google_compute_network" "vpc-a" {
  name                    = "vpc-a"
  auto_create_subnetworks = "false"
}

# vpc-b
resource "google_compute_network" "vpc-b" {
  name                    = "vpc-b"
  auto_create_subnetworks = "false"
}

# Subnet 1 in vpc-a
resource "google_compute_subnetwork" "subnet-1-in-vpc-a" {
  name          = "subnet-1-in-vpc-a"
  ip_cidr_range = "10.1.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc-a.id
}

# Subnet 2 in vpc-a
resource "google_compute_subnetwork" "subnet-2-in-vpc-a" {
  name          = "subnet-2-in-vpc-a"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc-a.id
}

# Subnet 1 in vpc-b
resource "google_compute_subnetwork" "subnet-1-in-vpc-b" {
  name          = "subnet-1-in-vpc-b"
  ip_cidr_range = "10.3.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc-b.id
  secondary_ip_range {
    range_name    = "subnet-1-in-vpc-b-secondary"
    ip_cidr_range = "192.168.10.0/24"
  }
}

# VPC Peering vpc-a
resource "google_compute_network_peering" "peering-1-in-vpc-a" {
  name         = "peering-1-in-vpc-a"
  network      = google_compute_network.vpc-a.self_link
  peer_network = google_compute_network.vpc-b.self_link
}

# VPC Peering vpc-b
resource "google_compute_network_peering" "peering-1-in-vpc-b" {
  name         = "peering-1-in-vpc-b"
  network      = google_compute_network.vpc-b.self_link
  peer_network = google_compute_network.vpc-a.self_link
}

