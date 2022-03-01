 resource "google_storage_bucket" "backend-bucket" {
  project       = var.project_id
  name          = var.bucket_name
  location      = var.region

  force_destroy = true
  storage_class = "REGIONAL"
  versioning {
    enabled = true
  }
} 

 output "bucket_name" {
    value = google_storage_bucket.backend-bucket
} 