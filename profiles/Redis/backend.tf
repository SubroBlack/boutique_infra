terraform {
  backend "gcs" {
    bucket = "terraform_state_bucket_uwa"
    prefix = "terraform/redis_tfstate"
  }
}
