
# GKE networks
resource "google_compute_network" "GKE_network" {
  name       = "${var.name}-${var.random_string}-gke-network"
  auto_create_subnetworks = false
}
# GKE Subnet
resource "google_compute_subnetwork" "GKE_subnet" {
  name          = "${var.name}-${var.random_string}-gke-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.GKE_network.name
}

# Address Range for Private REDIS peering
resource "google_compute_global_address" "Redis_range" {
  name          = "${var.name}-${var.random_string}-redis-address-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.GKE_network.id
}

# Private Services Access between GKE Network and Redis Network
resource "google_service_networking_connection" "private_Redis_connection" {
  network                 = google_compute_network.GKE_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.Redis_range.name]
}

/*

# REDIS network
resource "google_compute_network" "Redis_network" {
  name       = "${var.name}-${var.random_string}-redis-network"
  auto_create_subnetworks = false
}
# Redis Subnet
resource "google_compute_subnetwork" "Redis_subnet" {
  name          = "${var.name}-${var.random_string}-redis-subnet"
  ip_cidr_range = "10.3.0.0/16"
  region        = var.region
  network       = google_compute_network.Redis_network.name
}

# Creating a mutual peering among two networks 
module "gke_peering" {
  source       = "../../modules/peering"
  name         = "${var.name}-${var.random_string}-gke-peering"
  network      = google_compute_network.GKE_network.self_link
  peer_network = google_compute_network.Redis_network.self_link
}
module "redis_peering" {
  source       = "../../modules/peering"
  name         = "${var.name}-${var.random_string}-redis-peering"
  network      = google_compute_network.Redis_network.self_link
  peer_network = google_compute_network.GKE_network.self_link
}

*/