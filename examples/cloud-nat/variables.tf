variable "project-id" {
  description = "GCP Project ID"
  type        = string
}

variable "credential-file" {
  description = "Service Account Credentials"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Availability Zone"
  type        = string
  default     = "us-central1-c"
}

