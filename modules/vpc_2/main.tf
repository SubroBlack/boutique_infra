resource "google_compute_network" "vpc_network_2" {
  name                    = "vpc-2"
  auto_create_subnetworks = false
  project            = var.project_2
}

resource "google_compute_subnetwork" "vpc_2_subnet" {
  name          = "vpc-2-subnet"
  ip_cidr_range = "10.8.0.0/16"
  project       = var.project_2
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
