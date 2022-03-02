module "redis" {
  source = "../../modules/Redis"
  region = var.region
}

module "gke_peering" {
  source       = "../../modules/peering"
  name         = "gke_peer"
  network_1     = module.gke_cluster.vpc_gke_output.self_link
  network_2 = module.redis.vpc_redis_output.self_link
}

module "redis_peering" {
  source       = "../../modules/peering"
  name         = "redis_peer"
  network_1     = module.redis.vpc_redis_output.self_link
  network_2 = module.gke_cluster.vpc_gke_output.self_link
}


