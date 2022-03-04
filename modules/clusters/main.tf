resource "google_container_cluster" "primary" {
  project = var.project_id
  name     = var.name
  location = var.location
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  node_config {
    preemptible  = true
    machine_type = "g1-small"
    disk_type = "pd-standard"
    disk_size_gb = 50
  }

  #remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
  network = var.network
  subnetwork = var.subnetwork
}

# Namespace in the cluster for respective env virtual clusters
resource "kubernetes_namespace" "env" {
  metadata {

    labels = {
      env = var.env
    }

    name = var.env
  }
}