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
  source     = "../../modules/networks"
  project_id = var.project_id
  name       = "${var.name}-${module.random.random_string}-gke-network"
}
# GKE Subnet
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "${var.name}-${module.random.random_string}-gke-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = module.GKE_network.name
}

# REDIS network
module "Redis_network" {
  source     = "../../modules/networks"
  project_id = var.project_id
  name       = "${var.name}-${module.random.random_string}-redis-network"
}
# Redis Subnet
resource "google_compute_subnetwork" "redis_subnet" {
  name          = "${var.name}-${module.random.random_string}-redis-subnet"
  ip_cidr_range = "10.3.0.0/16"
  region        = var.region
  network       = module.Redis_network.name
}

# GKE cluster
module "GKE_cluster" {
  source     = "../../modules/clusters"
  project_id = var.project_id
  name       = "${var.name}-${module.random.random_string}-gke-cluster"
  network    = module.GKE_network.self_link
  subnetwork = google_compute_subnetwork.gke_subnet.self_link
}

# Creating a mutual peering among two networks 
module "gke_peering" {
  source       = "../../modules/peering"
  name         = "${var.name}-${module.random.random_string}-gke-peering"
  network      = module.GKE_network.self_link
  peer_network = module.Redis_network.self_link
}
module "redis_peering" {
  source       = "../../modules/peering"
  name         = "${var.name}-${module.random.random_string}-redis-peering"
  network      = module.Redis_network.self_link
  peer_network = module.GKE_network.self_link
}