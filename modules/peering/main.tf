resource "google_compute_network_peering" "peering" {
  name         = var.peer_name
  network     = var.network_1
  peer_network = var.network_2
}
