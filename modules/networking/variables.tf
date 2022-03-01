variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "name prefix for resources"
  type        = string
}

variable "random_string" {
  description = "Random String for naming purpose"
  type = string
}

variable "region" {
  description = "The location region/zone where the cluster should be deployed"
  type        = string
}

variable "env" {
  description = "Environment to run the Deployment at"
  type        = string
}