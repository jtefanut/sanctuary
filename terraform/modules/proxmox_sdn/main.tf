# Proxmox SDN design metadata only. No Proxmox SDN API resources are
# created by this module; configure zones/VNets on the cluster separately.
terraform {
  required_version = ">= 1.8.0"
}

variable "sdn_zones" {
  type = map(object({
    type = string
    ipam = optional(string, "pve")
    mtu  = optional(number, 1500)
  }))
  default = {
    "datacenter-vlan" = {
      type = "vlan"
      ipam = "pve"
      mtu  = 1500
    }
  }
  description = "Planned Proxmox SDN zones"
}

variable "vnets" {
  type = map(object({
    zone    = string
    tag     = optional(number)
    subnet  = string
    gateway = string
    comment = string
  }))
  default = {
    "vnet-mgmt" = {
      zone = "datacenter-vlan"
      tag = 10
      subnet = "10.10.10.0/24"
      gateway = "10.10.10.1"
      comment = "Management and shared service segment"
    }
    "vnet-core" = {
      zone = "datacenter-vlan"
      tag = 20
      subnet = "10.10.20.0/24"
      gateway = "10.10.20.1"
      comment = "Core workloads"
    }
    "vnet-cyber" = {
      zone = "datacenter-vlan"
      tag = 30
      subnet = "10.10.30.0/24"
      gateway = "10.10.30.1"
      comment = "Cyber range and malware analysis"
    }
    "vnet-dmz" = {
      zone = "datacenter-vlan"
      tag = 40
      subnet = "10.10.40.0/24"
      gateway = "10.10.40.1"
      comment = "DMZ and honeypots"
    }
    "vnet-iot" = {
      zone = "datacenter-vlan"
      tag = 50
      subnet = "10.10.50.0/24"
      gateway = "10.10.50.1"
      comment = "IoT and edge devices"
    }
  }
  description = "VNet plan aligned with terraform/main.tf VLAN definitions"
}

output "zones" {
  value       = var.sdn_zones
  description = "Planned Proxmox SDN zones"
}

output "virtual_networks" {
  value       = var.vnets
  description = "Planned Proxmox SDN VNets"
}
