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


# for the private service access that the redis instance needs for communication
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network_redis.id
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = google_compute_network.vpc_network_redis.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}


#redis instance 

resource "google_redis_instance" "cache" {
  name           = "private-cache"
  tier           = "STANDARD_HA"
  memory_size_gb = 1

  location_id             = "europe-north1-a"
  alternative_location_id = "us-central1-f"

  authorized_network = google_compute_network.vpc_network_redis.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version     = "REDIS_4_0"
  display_name      = "Terraform Test Instance"

  depends_on = [google_service_networking_connection.private_service_connection]

}
