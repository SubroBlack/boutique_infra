variable "region" {
  description = "network region"
  type = string
}
variable "zone" {
  description = "network zone"
  type = string
}
variable "machine_type" {
  type = string
  description = "Type of virtual machine"
  
}
variable "vm_name" {
  type = string
  description = "Name of the virtual machine"
}
variable "boot_disk_image" {
  type = string
  description = "Boot disk image"
 
}

variable "project_2" {
  type = string
  description = "Name of the second project"
}
