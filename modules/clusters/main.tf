resource "google_container_cluster" "primary" {
  project = var.project_id
  name     = var.name
  location = var.location
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  remove_default_node_pool = true
  initial_node_count       = 1
  network = var.network
  subnetwork = var.subnetwork

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_type = "pd-standard"
    disk_size_gb = 50
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/20"
    services_ipv4_cidr_block = "/20"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  cluster_autoscaling {             // cluster is auto scaleable
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

}

# Namespace in the cluster for respective env virtual clusters
resource "kubernetes_namespace_v1" "env" {
  metadata {
    annotations = {
      name = var.env
    }

    labels = {
      env = var.env
    }

    name = var.env
  }
}

/*
resource "kubernetes_namespace" "dev" {
  metadata {

    labels = {
      env = "dev"
    }

    name = "dev"
  }
}
*/