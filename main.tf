terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.11.0"
    }
  }
}

provider "google" {
  project = "test-project-ws-342013" // Use project name
  region  = "us-central1"
}

provider "kubernetes" {

  host  = "https://${local.cluster-endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    local.cluster-certificate,
  )
}

data "google_client_config" "default" { }

resource "google_compute_network" "vpc_network_gke" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

# resource "google_compute_network" "vpc_network_redis" {
  # name                    = "redis-vpc"
  # auto_create_subnetworks = false
# }
# 
resource "google_compute_subnetwork" "gke-subnet" {
  name          = "gke-vpc-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network_gke.name
}

# resource "google_compute_subnetwork" "redis-subnet" {
  # name          = "redis-vpc-subnet"
  # ip_cidr_range = "10.3.0.0/16"
  # region        = "us-central1"
  # network       = google_compute_network.vpc_network_redis.name
# }


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

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
     }
   }

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

resource "kubernetes_namespace" "dev-namespace" {
  metadata {
    annotations = {
      name = "dev-namespace"
    }

    labels = {
      namespace = "dev"
    }

    name = "dev-namespace"
  }
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

locals {
  cluster-certificate = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  cluster-endpoint = google_container_cluster.primary.endpoint
  cluster-id = google_container_cluster.primary.id
}
