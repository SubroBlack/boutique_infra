# Module to generate random string
module "random" {
  source = "../../modules/random"
}

## Module to create the necessary networks and peering
module "Networking" {
  source        = "../../modules/networking"
  project_id    = var.project_id
  random_string = module.random.random_string
  name          = var.name
  region        = var.region
  env           = var.env
}


# GKE cluster
module "GKE_cluster" {
  source     = "../../modules/clusters"
  project_id = var.project_id
  name       = "${var.name}-${module.random.random_string}-gke-cluster"
  network    = module.Networking.GKE_network.self_link
  subnetwork = module.Networking.GKE_subnetwork.self_link
  env = var.env
}


## GKE Redis Instant 
resource "google_redis_instance" "Redis" {
  name               = "${var.name}-${module.random.random_string}-redis-memory-cache-${var.env}"
  tier               = "STANDARD_HA"
  location_id        = var.zone
  memory_size_gb     = 1
  project            = var.project_id
  authorized_network = module.Networking.GKE_network.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"
  depends_on         = [module.Networking.private_Redis_connection]
}