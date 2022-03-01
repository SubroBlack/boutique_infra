// Resource to generate the Random string for the naming convention
resource "random_string" "random" {
  length = 4
  special = false
  lower = true
  number = false
  upper = false
}