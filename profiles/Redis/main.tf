module "redis" {
  source = "../../modules/Redis"
  region = var.region
}
