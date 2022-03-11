variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_team2a" {
  description = "GCP Project ID"
  type        = string
}

variable "project_team2b" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "name prefix for resources"
  type        = string
}

variable "region" {
  description = "The region where the resource should be deployed"
  type        = string
}

variable "zone" {
  description = "The zone where the resource should be deployed"
  type        = string
}

variable "env" {
  description = "Environment to run the Deployment at"
  type        = string
}