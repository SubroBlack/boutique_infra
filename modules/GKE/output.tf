output "output_cluster_id" {
    value = google_container_cluster.primary.id
    description = "Outputs cluster id"
}

output "output_cluster_endpoint" {
    value = google_container_cluster.primary.endpoint
    description = "Outputs cluster endpoint"
}

output "output_cluster_certificate" {
    value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
    description = "Outputs cluster certificate"
}

output "vpc_gke_output" {
    value = google_compute_network.vpc_network_gke
    description = "Output for the network self link"
}

