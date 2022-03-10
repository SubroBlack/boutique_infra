terraform {
  backend "gcs" {
    bucket = "tfstate_backend_storage"
    prefix = "terraform/gke_tfstate"
  }
}