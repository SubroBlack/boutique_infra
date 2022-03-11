terraform {
  backend "gcs" {
    bucket = "trial-bucket-microservices"
    prefix = "terraform/team-2"
  }
}
