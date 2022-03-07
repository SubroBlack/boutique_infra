# Backend file for Dev environment

terraform {
  backend "gcs" {
      bucket = "boutique-terrastore"
      prefix = "env/dev"
  }
}