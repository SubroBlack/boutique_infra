# ------- Cluster ---------

resource "google_container_cluster" "primary" {                               // creates google kubernetes cluster
  name               = var.cluster_name
  location           = var.region
  network            = google_compute_network.vpc_network_gke.self_link
  subnetwork         = google_compute_subnetwork.gke-subnet.self_link   
  
  initial_node_count = 1
  remove_default_node_pool = true

  node_config {
    preemptible  = true
    machine_type = "g1-small"     //f1-micro does not have enough memory to support GKE.

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  
  ip_allocation_policy {
    cluster_secondary_range_name  = "services-range"
    services_secondary_range_name = google_compute_subnetwork.gke-subnet.secondary_ip_range[1].range_name
  }

  # google_compute_subnetwork.gke-subnet.secondary_ip_range[0].range_name

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes = true
    master_ipv4_cidr_block = "10.5.6.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }

  master_auth {
  client_certificate_config {
    issue_client_certificate = true
   }
 }

 cluster_autoscaling {     // cluster is auto scaleable
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 6
    }
    resource_limits {
      resource_type = "memory"
      minimum = 4
      maximum = 16
    }
  }

  depends_on = [google_compute_network.vpc_network_gke]
}

# ------- Nodepool --------

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "custom-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 5

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
   #service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# ------- Networks --------

resource "google_compute_network" "vpc_network_gke" {
  name                    = "gke-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke-subnet" {
  name          = "gke-vpc-subnet"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network_gke.name

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.24.0.0/20"
  }

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.28.0.0/20"
  }
}

resource "google_compute_firewall" "gke" {
  name    = "ingress-firewall-gke"
  network = google_compute_network.vpc_network_gke.name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}

# ------- Namespaces -------

# resource "kubernetes_namespace" "development" {
#   metadata {

#     labels = {
#       env = "dev"
#     }

#     name = "development"
#   }
# }

# resource "kubernetes_namespace" "staging" {
#   metadata {

#     labels = {
#       env = "stg"
#     }

#     name = "staging"
#   }
# }

# resource "kubernetes_namespace" "production" {
#   metadata {

#     labels = {
#       env = "prod"
#     }

#     name = "production"
#   }
# }

# for the private service access that the redis instance needs for communication
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  # project       = var.project_1
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network_gke.id
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = google_compute_network.vpc_network_gke.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# ----- Redis Instance ----- 

resource "google_redis_instance" "cache" {
  name           = "private-cache"
  tier           = "STANDARD_HA"
  # project         = var.project_1
  memory_size_gb = 1

  location_id             = "us-west1-a"
  alternative_location_id = "us-west1-b"

  authorized_network = google_compute_network.vpc_network_gke.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version     = "REDIS_4_0"
  display_name      = "Terraform Test Instance"

  depends_on = [google_service_networking_connection.private_service_connection]

}
