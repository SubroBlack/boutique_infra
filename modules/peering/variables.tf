variable "name" {
  description = "(Required) Name of the peering"
  type = string
}

variable "network" {
  description = "(Required) The primary network of the peering"
  type = string
}

variable "peer_network" {
  description = "(Required) The peer network in the peering. The peer network may belong to a different project."
  type = string
}
