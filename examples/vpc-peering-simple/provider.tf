terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.18.0"
    }
  }
}

provider "google" {
  credentials = file(var.credential-file)
  project     = var.project-id
  region      = var.region
  zone        = var.zone
}

