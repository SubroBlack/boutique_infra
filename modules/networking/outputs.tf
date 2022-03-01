output "GKE_network_link" {
    description = "Self Link of GKE network"
    value = google_compute_network.GKE_network.self_link
}

output "GKE_subnetwork_link" {
    description = "Self Link of GKE subnetwork"
    value = google_compute_subnetwork.GKE_subnet.self_link
}