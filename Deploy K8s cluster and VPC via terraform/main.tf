

/* output "output-cluster-endpoint" {
    value = google_container_cluster.primary.endpoint
    description = "Outputs cluster endpoint"
}

output "output-cluster-certificate" {
    value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    description = "Outputs cluster certificate"
} */

module "gke_cluster" {
  source = "./modules/create_clusters"
  cluster_name = var.cluster_name
  region = var.region
}
