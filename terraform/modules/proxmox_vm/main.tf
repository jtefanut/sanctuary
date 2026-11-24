terraform {
  required_version = ">= 1.8.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.60.0"
    }
  }
}

locals {
  effective_network_devices = var.network_devices == null ? [
    {
      bridge      = var.bridge
      vlan_id     = var.vlan_tag
      firewall    = true
      mac_address = var.mac_address
    }
  ] : var.network_devices
}

resource "proxmox_virtual_environment_vm" "vm" {
  node_name   = var.target_node
  vm_id       = var.vmid
  name        = var.name
  description = var.description
  tags        = var.tags
  on_boot     = var.onboot
  started     = true

  # Enable only after QEMU guest agent is installed inside the guest.
  agent {
    enabled = var.agent_enabled
  }

  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.memory
    floating  = var.balloon > 0 ? var.balloon : var.memory
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = var.storage_pool
    size         = var.disk_size
    interface    = "scsi0"
    iothread     = true
    discard      = "on"
    ssd          = true
  }

  dynamic "cdrom" {
    for_each = var.iso_file_id != "" ? [1] : []
    content {
      file_id   = var.iso_file_id
      interface = "ide2"
    }
  }

  dynamic "network_device" {
    for_each = local.effective_network_devices
    content {
      bridge      = network_device.value.bridge
      vlan_id     = try(network_device.value.vlan_id, null)
      model       = "virtio"
      mac_address = try(network_device.value.mac_address, "") != "" ? network_device.value.mac_address : null
      firewall    = try(network_device.value.firewall, true)
    }
  }

  operating_system {
    type = var.os_type
  }

  dynamic "hostpci" {
    for_each = var.pci_passthrough_device != "" ? [1] : []
    content {
      device = "hostpci0"
      id     = var.pci_passthrough_device
      pcie   = true
      rombar = true
    }
  }
}
