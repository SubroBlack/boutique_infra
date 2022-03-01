terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.11.0"
    }
  }
}

provider "google" {
  project = "**********" // Use project name
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network_gke" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_network" "vpc_network_redis" {
  name                    = "redis-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke-subnet" {
  name          = "gke-vpc-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network_gke.name
}

resource "google_compute_subnetwork" "redis-subnet" {
  name          = "redis-vpc-subnet"
  ip_cidr_range = "10.3.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network_redis.name
}


resource "google_container_cluster" "primary" { // creates google kubernetes cluster
  name               = "gke-test-cluster"
  location           = "us-central1-a"
  initial_node_count = 3                                          
  network            = google_compute_network.vpc_network_gke.self_link // Cluster deployed in ustom network 
  subnetwork         = google_compute_subnetwork.gke-subnet.self_link   // Cluster deployed in ustom subnetwork 

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }

  #   master_auth {
  #   client_certificate_config {
  # issue_client_certificate = true
  #    }
  #  }

  cluster_autoscaling { // cluster is auto scaleable
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = 1
      maximum       = 6
    }
    resource_limits {
      resource_type = "memory"
      minimum       = 4
      maximum       = 16
    }
  }
  depends_on = [google_compute_network.vpc_network_gke]
}