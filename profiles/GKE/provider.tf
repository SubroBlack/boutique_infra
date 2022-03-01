provider "google" {
    project = var.project_id
    region = var.region
}

provider "kubernetes" {
  host  = "https://${module.gke_cluster.output-cluster-endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    module.gke_cluster.output_cluster_certificate
  )
}
data "google_client_config" "default" {}
