module "gke_cluster" {
  source = "../../modules/GKE"
  cluster_name = var.cluster_name
  region = var.region
  project_1 = var.project_1
  # project_1_number = var.project_1_number

}

module "vpc2" {
  source = "../../modules/vpc_2"
  region = var.region
  project_2 = var.project_2 
}

resource "google_compute_network_peering" "gke-vpc2" {
  name = var.peer_name_1
  network  = module.gke_cluster.vpc_gke_output.self_link
  peer_network = module.vpc2.vpc2_output.self_link
}

resource "google_compute_network_peering" "vpc2-gke" {
  name =  var.peer_name_2
  network = module.vpc2.vpc2_output.self_link
  peer_network  = module.gke_cluster.vpc_gke_output.self_link
}
