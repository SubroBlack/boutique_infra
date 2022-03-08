terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.12.0"
    }
  }
}

provider "google" {
  //credentials = file("<NAME>.json")
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host  = "https://${module.GKE_cluster.output-cluster-endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    module.GKE_cluster.output-cluster-certificate
  )
}
data "google_client_config" "default" {}
