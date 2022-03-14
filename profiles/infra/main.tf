# Module to generate random string
/* module "random" {
  source = "../../modules/random"
} */

## Module to create the necessary networks and peering
module "Networking" {
  source     = "../../modules/networking"
  project_id = var.project_id
  name       = var.name
  region     = var.region
  env        = var.env
}

/*
# GKE cluster
module "GKE_cluster" {
  source         = "../../modules/clusters"
  project_id     = var.project_id
  name           = "${var.name}-gke-cluster"
  network        = module.Networking.GKE_network
  subnetwork     = module.Networking.GKE_subnetwork
  services_range = module.Networking.GKE_subnetwork.secondary_ip_range[0].range_name
  pods_range     = module.Networking.GKE_subnetwork.secondary_ip_range[1].range_name
  env            = var.env
}

## GKE Redis Instant 
resource "google_redis_instance" "Redis" {
  name               = "${var.name}-redis-memory-cache"
  tier               = "STANDARD_HA"
  location_id        = var.zone
  memory_size_gb     = 1
  project            = var.project_id
  authorized_network = module.Networking.GKE_network.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  depends_on         = [module.Networking.private_Redis_connection]
}
*/