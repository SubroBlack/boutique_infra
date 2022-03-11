
# GKE networks
resource "google_compute_network" "GKE_network" {
  name       = "${var.name}-gke-network"
  auto_create_subnetworks = false
}
# GKE Subnet
resource "google_compute_subnetwork" "GKE_subnet" {
  name          = "${var.name}-gke-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.GKE_network.name
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.24.0.0/20"
    }
  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.28.0.0/20"
  }
}

# Firwall rule to allow ingress
resource "google_compute_firewall" "gke" {
  name    = "${var.name}-ingress-firewall-gke"
  network = google_compute_network.GKE_network.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

}


# Address Range for Private REDIS peering
resource "google_compute_global_address" "Redis_range" {
  name          = "${var.name}-redis-address-range"
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