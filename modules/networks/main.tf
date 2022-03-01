# Network Module
resource "google_compute_network" "network" {
  project = var.project_id
  name = var.name
  auto_create_subnetworks = false
}