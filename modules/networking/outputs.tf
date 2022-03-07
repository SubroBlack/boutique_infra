output "GKE_network" {
    description = "GKE network"
    value = google_compute_network.GKE_network
}

output "GKE_subnetwork" {
    description = "GKE subnetwork"
    value = google_compute_subnetwork.GKE_subnet
}

output "private_Redis_connection" {
    description = "Private Services Access between GKE Network and Redis Network"
    value = google_service_networking_connection.private_Redis_connection
}

/*

output "GKE_network_name" {
    description = "Name of GKE network"
    value = google_compute_network.GKE_network.name
}

output "Redis_network_name" {
    description = "Name of Redis network"
    value = google_compute_network.Redis_network.name
}

output "Redis_subnetwork_id" {
  description = "ID of Redis subnetwork"
    value = google_compute_subnetwork.Redis_subnet.id
}

*/