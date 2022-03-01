terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  //credentials = file("<NAME>.json")
  project = var.project_id
}

# Module to generate random string
module "random" {
  source = "../../modules/random"
}

## Module to create the necessary networks and peering
module "Networking" {
  source     = "../../modules/networking"
  project_id = var.project_id
  #random_string = module.random.random_string
  name          = var.name
  region        = var.region
  env           = var.env
  random_string = module.random.random_string
}


# GKE cluster
module "GKE_cluster" {
  source     = "../../modules/clusters"
  project_id = var.project_id
  name       = "${var.name}-${module.random.random_string}-gke-cluster"
  network    = module.Networking.GKE_network_link
  subnetwork = module.Networking.GKE_subnetwork_link
}
