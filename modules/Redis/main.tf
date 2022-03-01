resource "google_compute_network" "vpc_network_redis" {
  name                    = "redis-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "redis-subnet" {
  name          = "redis-subnet"
  ip_cidr_range = "10.8.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network_redis.name
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.5.0/24"
    }
}
