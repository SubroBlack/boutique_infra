terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.11.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  # load_config_file = "false"
  host  = "https://${module.gke_cluster.output-cluster-endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    module.gke_cluster.output-cluster-certificate
  )
  config_path    = "~/.kube/config"
}
data "google_client_config" "default" {}
