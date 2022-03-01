
# GKE networks
resource "google_compute_network" "GKE_network" {
  name       = "${var.name}-${var.random_string}-gke-network-${var.env}"
  auto_create_subnetworks = false
}
# GKE Subnet
resource "google_compute_subnetwork" "GKE_subnet" {
  name          = "${var.name}-${var.random_string}-gke-subnet-${var.env}"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.GKE_network.name
}

# REDIS network
resource "google_compute_network" "Redis_network" {
  name       = "${var.name}-${var.random_string}-redis-network-${var.env}"
  auto_create_subnetworks = false
}
# Redis Subnet
resource "google_compute_subnetwork" "Redis_subnet" {
  name          = "${var.name}-${var.random_string}-redis-subnet-${var.env}"
  ip_cidr_range = "10.3.0.0/16"
  region        = var.region
  network       = google_compute_network.Redis_network.name
}

# Creating a mutual peering among two networks 
module "gke_peering" {
  source       = "../../modules/peering"
  name         = "${var.name}-${var.random_string}-gke-peering-${var.env}"
  network      = google_compute_network.GKE_network.self_link
  peer_network = google_compute_network.Redis_network.self_link
}
module "redis_peering" {
  source       = "../../modules/peering"
  name         = "${var.name}-${var.random_string}-redis-peering-${var.env}"
  network      = google_compute_network.Redis_network.self_link
  peer_network = google_compute_network.GKE_network.self_link
}