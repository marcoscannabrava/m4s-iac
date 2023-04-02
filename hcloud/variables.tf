# Variables for Hetzner Cloud infrastructure module

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token used to create infrastructure"
}

variable "hcloud_location" {
  type        = string
  description = "Hetzner location used for all resources"
  default     = "hil"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "network_cidr" {
  type        = string
  description = "Network to create for private communication"
  default     = "10.0.0.0/8"
}

variable "network_ip_range" {
  type        = string
  description = "Subnet to create for private communication. Must be part of the CIDR defined in `network_cidr`."
  default     = "10.0.1.0/24"
}

variable "network_zone" {
  type        = string
  description = "Zone to create the network in"
  default     = "us-west"
}

variable "instance_type" {
  type        = string
  description = "Type of instance to be used for all instances"
  default     = "cpx21"
}

# Local variables used to reduce repetition
locals {
  node_username = "root"
}
