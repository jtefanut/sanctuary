variable "target_node" {
  type        = string
  description = "Target Proxmox node"
  default     = "pve"
  validation {
    condition     = length(var.target_node) > 0
    error_message = "target_node must not be empty."
  }
}

variable "vmid" {
  type        = number
  description = "Unique Proxmox guest ID"
  validation {
    condition     = var.vmid >= 100 && var.vmid <= 999
    error_message = "vmid must be between 100 and 999."
  }
}

variable "name" {
  type        = string
  description = "VM name"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name must contain lowercase letters, numbers and hyphens only."
  }
}

variable "description" {
  type    = string
  default = "Managed declaratively via Terraform"
}

variable "cores" {
  type    = number
  default = 2
  validation {
    condition     = var.cores >= 1 && var.cores <= 32
    error_message = "cores must be between 1 and 32."
  }
}

variable "sockets" {
  type    = number
  default = 1
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "memory" {
  type    = number
  default = 2048
  validation {
    condition     = var.memory >= 512 && var.memory <= 65536
    error_message = "memory must be between 512 MB and 65536 MB."
  }
}

variable "disk_size" {
  type    = number
  default = 32
  validation {
    condition     = var.disk_size >= 1 && var.disk_size <= 2000
    error_message = "disk_size must be between 1 GB and 2000 GB."
  }
}

variable "storage_pool" {
  type    = string
  default = "local-lvm"
}

variable "iso_file_id" {
  type        = string
  description = "Optional Proxmox ISO file ID, e.g. local:iso/debian.iso"
  default     = ""
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "vlan_tag" {
  type    = number
  default = 20
}

variable "mac_address" {
  type    = string
  default = ""
}

variable "tags" {
  type    = list(string)
  default = ["terraform", "homelab", "vm"]
}

variable "pci_passthrough_device" {
  type        = string
  description = "Optional PCI device ID; requires provider authentication compatible with PCI passthrough."
  default     = ""
}

variable "onboot" {
  type    = bool
  default = true
}

variable "balloon" {
  type    = number
  default = 0
}

variable "os_type" {
  type        = string
  description = "Proxmox guest OS type"
  default     = "l26"
  validation {
    condition     = contains(["l24", "l26", "other", "solaris", "w2k", "w2k3", "w2k8", "win7", "win8", "win10", "win11", "wvista", "wxp"], var.os_type)
    error_message = "Unsupported Proxmox guest OS type."
  }
}

variable "agent_enabled" {
  type        = bool
  description = "Enable only after QEMU guest agent is installed in the guest."
  default     = false
}
