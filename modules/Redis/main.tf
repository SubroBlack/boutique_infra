locals {
 redis_ip = "${google_redis_instance.cache.host}"
 
}

resource "google_compute_network" "vpc_network_redis" {
  name                    = "redis-vpc"
  auto_create_subnetworks = false
  project            = var.project_2
}

resource "google_compute_subnetwork" "redis-subnet" {
  name          = "redis-subnet"
  ip_cidr_range = "10.8.0.0/16"
  project            = var.project_2
  region        = var.region
  network       = google_compute_network.vpc_network_redis.name
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.5.0/28"
    }
}

resource "google_compute_firewall" "redis" {
  name    = "ingress-firewall-redis"
  project            = var.project_2
  network = google_compute_network.vpc_network_redis.name
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

# for the private service access that the redis instance needs for communication
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  project       = var.project_2
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
  project         = var.project_2
  memory_size_gb = 1

  location_id             = "europe-north1-a"
  alternative_location_id = "europe-north1-b"

  authorized_network = google_compute_network.vpc_network_redis.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version     = "REDIS_4_0"
  display_name      = "Terraform Test Instance"

  depends_on = [google_service_networking_connection.private_service_connection]

}

resource "google_compute_instance" "nutcracker" {
  project = var.project_2
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
}

  metadata_startup_script = <<SCRIPT
    #! bin/bash
    sudo apt-get update
    sudo apt-get -y install nutcracker
    sudo touch nutcracker.yaml
    sudo echo -e "redis-1:\n listen: 0.0.0.0:6379\n redis: true\n servers:\n - ${local.redis_ip}:6379:1" >> nutcracker.yaml
    sudo nutcracker --conf-file nutcracker.yaml
    SCRIPT
  network_interface {
    network = google_compute_network.vpc_network_redis.name
    subnetwork = google_compute_subnetwork.redis-subnet.self_link
    access_config {
      // Ephemeral public IP
        } 
    }
 
}

# for some reason, the nutcracker.yaml file does not get created with the startup script. 
# However nutcracker is installed from the startup script.
