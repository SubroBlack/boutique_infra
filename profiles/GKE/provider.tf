provider "google" {
    project = var.project_1
    region = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.11.0"
    }
  }
}


provider "kubernetes" {
  host  = "https://${module.gke_cluster.output_cluster_endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    module.gke_cluster.output_cluster_certificate
  )
}
data "google_client_config" "default" {}
