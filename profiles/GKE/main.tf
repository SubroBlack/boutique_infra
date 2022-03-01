module "gke_cluster" {
  source = "../modules/GKE"
  cluster_name = var.cluster_name
  region = var.region
}

