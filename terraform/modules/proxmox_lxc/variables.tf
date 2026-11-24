variable "target_node" {
  type    = string
  default = "pve"
  validation {
    condition     = length(var.target_node) > 0
    error_message = "target_node must not be empty."
  }
}
variable "vmid" {
  type = number
  validation {
    condition     = var.vmid >= 100 && var.vmid <= 999
    error_message = "vmid must be between 100 and 999."
  }
}
variable "hostname" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.hostname))
    error_message = "hostname must contain lowercase letters, numbers and hyphens only."
  }
}
variable "ostemplate" {
  type = string
}
variable "ostype" {
  type = string
  validation {
    condition     = contains(["debian", "alpine", "ubuntu"], var.ostype)
    error_message = "Supported OS types: debian, alpine, ubuntu."
  }
}
variable "cores" {
  type    = number
  default = 2
  validation {
    condition     = var.cores >= 1 && var.cores <= 16
    error_message = "cores must be between 1 and 16."
  }
}
variable "memory" {
  type    = number
  default = 512
  validation {
    condition     = var.memory >= 16 && var.memory <= 32768
    error_message = "memory must be between 16 MB and 32768 MB."
  }
}
variable "swap" {
  type    = number
  default = 512
}
variable "disk_size" {
  type    = string
  default = "8G"
  validation {
    condition     = can(regex("^[0-9]+G$", var.disk_size))
    error_message = "disk_size must use integer gigabytes, e.g. 16G."
  }
}
variable "storage_pool" {
  type    = string
  default = "local-lvm"
}
variable "ip_address" {
  type = string
  validation {
    condition     = can(regex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/[0-9]{1,2}$", var.ip_address))
    error_message = "ip_address must be a valid IPv4 CIDR."
  }
}
variable "gateway" {
  type    = string
  default = "192.168.1.1"
  validation {
    condition     = can(cidrhost("${var.gateway}/32", 0))
    error_message = "gateway must be a valid IPv4 address."
  }
}
variable "nameserver" {
  type    = string
  default = "192.168.1.1"
}
variable "bridge" {
  type    = string
  default = "vmbr0"
}
variable "vlan_tag" {
  type    = number
  default = 10
}
variable "unprivileged" {
  type    = bool
  default = true
}
variable "nesting" {
  type    = bool
  default = true
}
variable "keyctl" {
  type        = bool
  description = "Enable keyctl for nested container runtimes where required."
  default     = true
}
variable "onboot" {
  type        = bool
  description = "Start this container automatically when the Proxmox node boots."
  default     = true
}
variable "device_passthrough" {
  type        = list(string)
  description = "Host device paths to pass through, e.g. /dev/net/tun or NVIDIA device nodes."
  default     = []
}
variable "tags" {
  type    = list(string)
  default = ["terraform", "homelab"]
}
variable "ssh_public_keys" {
  type        = list(string)
  description = "Authorized SSH public keys; set real keys through private configuration."
  default     = []
}
