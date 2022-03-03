resource "google_container_cluster" "primary" {                               // creates google kubernetes cluster
  name               = var.cluster_name
  location           = var.region
  initial_node_count = 1         
  network            = google_compute_network.vpc_network_gke.self_link
  subnetwork         = google_compute_subnetwork.gke-subnet.self_link   
  
  node_config {
    preemptible  = true
    machine_type = "g1-small"     //f1-micro does not have enough memory to support GKE.

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/20"
    services_ipv4_cidr_block = "/20"
  }
  timeouts {
    create = "30m"
    update = "40m"
  }

  master_auth {
  client_certificate_config {
    issue_client_certificate = true
   }
 }

 cluster_autoscaling {     // cluster is auto scaleable
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 6
    }
    resource_limits {
      resource_type = "memory"
      minimum = 4
      maximum = 16
    }
  }

  depends_on = [google_compute_network.vpc_network_gke]
}

resource "google_compute_network" "vpc_network_gke" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke-subnet" {
  name          = "gke-vpc-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network_gke.name

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.24.0.0/20"
  }
  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.28.0.0/20"
  }
}

resource "google_compute_firewall" "gke" {
  name    = "ingress-firewall-gke"
  network = google_compute_network.vpc_network_gke.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  
  depends_on = [google_compute_network.vpc_network_gke]
}

resource "kubernetes_namespace" "development" {
  metadata {

    labels = {
      env = "dev"
    }

    name = "development"
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {

    labels = {
      env = "stg"
    }

    name = "staging"
  }
}

resource "kubernetes_namespace" "production" {
  metadata {

    labels = {
      env = "prod"
    }

    name = "production"
  }
}

# locals {
#   cluster-certificate = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
#   cluster-endpoint = google_container_cluster.primary.endpoint
#   cluster-id = google_container_cluster.primary.id
# }
