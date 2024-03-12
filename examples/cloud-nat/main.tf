# vpc-a
resource "google_compute_network" "vpc-a" {
  name                    = "vpc-a"
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

# Cloud Router 1 in vpc-a
resource "google_compute_router" "cloud-router-1-vpc-a" {
  name    = "cloud-router-1-in-vpc-a"
  region  = google_compute_subnetwork.subnet-1-in-vpc-a.region
  network = google_compute_network.vpc-a.id
}

# Cloud NAT for all subnets of vpc-a in specific region
resource "google_compute_router_nat" "cloud-nat-1-vpc-a" {
  name                               = "cloud-nat-1-vpc-a"
  router                             = google_compute_router.cloud-router-1-vpc-a.name
  region                             = google_compute_router.cloud-router-1-vpc-a.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
