variable "name" {
  description = "name for resources"
  type        = string
}

variable "network" {
    description = "The network to which the cluster would belong"
    //type = string
    default = "default"
}

variable "subnetwork" {
    description = "The subnetwork to which the cluster would belong"
    //type = string
    default = "default"
}

variable "services_range" {
    description = "The secondary range in which the services would belong"
    type = string
}

variable "pods_range" {
    description = "The secondary range in which the pods would belong"
    type = string
}

variable "location" {
  description = "The location region/zone where the cluster should be deployed"
  type = string
  default = "europe-north1"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "env" {
  description = "ENV vairable for Namespace"
  type        = string
}