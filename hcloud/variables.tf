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

variable "hcloud_server" {
  type        = string
  description = "Type of instance to be used for all instances"
  default     = "cpx21"
}

variable "hcloud_image" {
  type        = string
  description = "System image to be used for all instances"
  default     = "ubuntu-22.04"
}

variable "cloudflare_token" {
  type        = string
  description = "Cloudflare API token used to add DNS records"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "domain" {
  type        = string
  description = "Domain URL to point server to"
  default     = "example.com"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

# Local variables used to reduce repetition
locals {
  node_username = "root"
}
