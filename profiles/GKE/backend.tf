terraform {
  backend "gcs" {
    bucket = "infra-microservices-test-342013"
    prefix = "terraform/gke_tfstate"
  }
}

