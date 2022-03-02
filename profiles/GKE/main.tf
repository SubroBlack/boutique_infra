module "gke_cluster" {
  source = "../../modules/GKE"
  cluster_name = var.cluster_name
  region = var.region
}




#need to work on this peering later considering that the network needs to exist before it can be peered

#how to create two networks in different projects under one tfstate file???