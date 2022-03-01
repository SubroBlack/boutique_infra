module "gke_cluster" {
  source = "../../modules/GKE"
  cluster_name = var.cluster_name
  region = var.region
}

module "gke_peering" {
  source       = "../../modules/peering"
  name         = "gke_peer"
  network      = module.gke_cluster.vpc_gke_output.self_link
  peer_network = module.redis.vpc_redis_output.self_link
}

module "redis_peering" {
  source       = "../../modules/peering"
  name         = "redis_peer"
  network      = module.redis.vpc_redis_output.self_link
  peer_network = module.gke_cluster.vpc_gke_output.self_link
}


#need to work on this peering later considering that the network needs to exist before it can be peered

#how to create two networks in different projects under one tfstate file???