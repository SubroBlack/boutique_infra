
provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  )
  config_path    = "~/.kube/config"
}
data "google_client_config" "default" {}


resource "google_container_cluster" "primary" {
  project = var.project_id
  name     = var.name
  location = var.region
  network = var.network.self_link
  subnetwork = var.subnetwork.self_link
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "10.5.6.0/28"
  }

  remove_default_node_pool = true
  initial_node_count       = 1

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

#Node Pool to be created 
resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    // service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
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
  depends_on = [
    var.network
  ]
}
