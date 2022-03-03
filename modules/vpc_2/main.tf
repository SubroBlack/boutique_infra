

resource "google_compute_network" "vpc_network_2" {
  name                    = "vpc-2"
  auto_create_subnetworks = false
  project            = var.project_2
}

resource "google_compute_subnetwork" "vpc_2_subnet" {
  name          = "vpc-2-subnet"
  ip_cidr_range = "10.8.0.0/16"
  project            = var.project_2
  region        = var.region
  network       = google_compute_network.vpc_network_2.name
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.5.0/28"
    }
}

resource "google_compute_firewall" "vpc_2" {
  name    = "ingress-firewall-vpc-2"
  project            = var.project_2
  network = google_compute_network.vpc_network_2.name
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

/*
resource "google_compute_instance" "nutcracker" {
  #project = var.project_2
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
    sudo echo -e "redis-1:\n listen: 0.0.0.0:6379\n redis: true\n servers:\n - ${local.redis_ip}:6379:1" >> nutcracker.yaml
    sudo nutcracker --conf-file /nutcracker.yaml
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
*/