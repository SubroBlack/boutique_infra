output "self_link" {
    description = "The Link of the Network"
    value = google_compute_network.network.self_link
}

output "name" {
    description = "The Name of the Network"
    value = google_compute_network.network.name
}