provider "google" {
    project = var.project_2
    region = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.11.0"
    }
  }
}
