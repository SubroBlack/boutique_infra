variable "cluster_name" {
  type = string
  description = "Name of the gke cluster"
}
variable "region" {
  type = string
  description = "Name of the cluster region"
}
variable "project_1" {
  type = string
  description = "id of the project for deployment"
}

variable "project_2" {
  type = string
  description = "id of the project for deployment"
}

variable "peer_name_1" {
  description = "Name of the first peer"
  type = string
}

variable "peer_name_2" {
  description = "Name of the second peer"
  type = string
}





