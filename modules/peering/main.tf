# Both networks must create a peering with each other for the peering to be functional.
# Subnets IP ranges across peered VPC networks cannot overlap.

resource "google_compute_network_peering" "peering" {
  name         = var.name
  network      = var.network
  peer_network = var.peer_network
}