terraform {
  required_version = ">= 1.8.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.60.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  node_name   = var.target_node
  vm_id       = var.vmid
  name        = var.name
  description = var.description
  tags        = var.tags
  on_boot     = var.onboot
  started     = true

  # Guest agent is opt-in: it must be installed and enabled inside the guest.
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

  network_device {
    bridge      = var.bridge
    vlan_id     = var.vlan_tag
    model       = "virtio"
    mac_address = var.mac_address != "" ? var.mac_address : null
    firewall    = true
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
