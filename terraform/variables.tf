variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox VE REST API URL; set via TF_VAR_proxmox_endpoint or a local tfvars file"
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox VE API Token (USER@REALM!TOKENID=UUID)"
  sensitive   = true
}

variable "proxmox_insecure" {
  type        = bool
  description = "Disable TLS certificate validation for internal self-signed certs"
  default     = false
}

variable "primary_node" {
  type        = string
  description = "Primary x86_64 Proxmox node name"
  default     = "pve"
}

variable "gateway_ip" {
  type        = string
  description = "Default LAN gateway IP"
  default     = "10.10.10.1"
}

variable "nameserver_ip" {
  type        = string
  description = "Default DNS nameserver IP"
  default     = "192.168.1.1"
}

variable "debian_template" {
  type        = string
  description = "Debian 13 x86_64 OS template"
  default     = "local:vztmpl/debian-13-standard_13.6-1_amd64.tar.zst"
}

variable "alpine_template" {
  type        = string
  description = "Alpine 3.24 x86_64 OS template"
  default     = "local:vztmpl/alpine-3.24-default_20260714_amd64.tar.xz"
}
