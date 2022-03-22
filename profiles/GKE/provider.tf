terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.11.0"
    }
  }
}

provider "google" {
    project = var.project_1
    region = var.region
}

data "google_project" "current" {}
 
data "google_service_account_access_token" "service_token" {
  provider = google
  target_service_account = var.tf_account
  scopes = ["userinfo-email", "cloud-platform"]
  lifetime = "3600s"
}

provider "google" {
  alias = "impersonated"
  access_token = "${data.google_service_account_access_token.service_token.access_token}"
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host  = "https://${module.gke_cluster.output_cluster_endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    module.gke_cluster.output_cluster_certificate
  )
  config_path    = "~/.kube/config"
}
data "google_client_config" "default" {}
