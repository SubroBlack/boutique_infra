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

# GKE networks
module "GKE_network" {
  source = "../../modules/networks"
  name   = "${var.name}-${module.random.random_string}-gke-network"
}

# REDIS network
module "Redis_network" {
  source = "../../modules/networks"
  name   = "${var.name}-${module.random.random_string}-redis-network"
}

# GKE cluster
module "GKE_cluster" {
  source  = "../../modules/clusters"
  name    = "${var.name}-${module.random.random_string}-gke-cluster"
  network = module.GKE_network.self_link
}