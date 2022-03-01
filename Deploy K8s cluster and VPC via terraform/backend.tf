terraform {
  backend "gcs" {
    bucket  = "infra-microservices-test-342013"
    prefix  = "terraform/state"
  }
  
    required_providers {
    google = "~>4.4.0"
  }
  required_version = "~>1.1.2"
}
