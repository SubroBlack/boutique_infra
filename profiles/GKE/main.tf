module "gke_cluster" {
  source = "../../modules/GKE"
  cluster_name = var.cluster_name
  region = var.region
  project_1 = var.project_1

}

module "redis" {
  source = "../../modules/Redis"
  region = var.region
  project_2 = var.project_2
  vm_name   = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  boot_disk_image= var.boot_disk_image
}


resource "google_compute_network_peering" "gke-redis" {
  name = var.peer_name_1
  network  = module.gke_cluster.vpc_gke_output.self_link
  peer_network = module.redis.vpc_redis_output.self_link
}


resource "google_compute_network_peering" "redis-gke" {
  name =  var.peer_name_2
  network = module.redis.vpc_redis_output.self_link
  peer_network  = module.gke_cluster.vpc_gke_output.self_link
}



#need to work on this peering later considering that the network needs to exist before it can be peered

#how to create two networks in different projects under one tfstate file???