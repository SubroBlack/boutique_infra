variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "name prefix for resources"
  type        = string
}

variable "env" {
  description = "Environment to run the Deployment at"
  type        = string
}