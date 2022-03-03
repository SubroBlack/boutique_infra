module "gke_cluster" {
  source = "./../../module/gke"

  cluster_name = var.cluster_name
  region       = var.region
}
