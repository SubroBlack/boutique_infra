variable "name" {
  description = "name for resources"
  type        = string
}

variable "initial_node_count" {
  description = "Number of initial nodes in the cluster"
  type = number
  default = 3
}

variable "network" {
    description = "The network to which the cluster would belong"
    type = string
    default = "default"
}

variable "subnetwork" {
    description = "The subnetwork to which the cluster would belong"
    type = string
    default = "default"
}

variable "location" {
  description = "The location region/zone where the cluster should be deployed"
  type = string
  default = "europe-north1-a"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}