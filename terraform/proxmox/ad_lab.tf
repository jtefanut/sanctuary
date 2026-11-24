module "vm_dc" {
  source       = "../modules/proxmox_vm"
  target_node  = var.primary_node
  vmid         = 400
  name         = "dc"
  description  = "Windows Server 2022 Domain Controller"
  cores        = 2
  memory       = 4096
  balloon      = 2048
  disk_size    = 60
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["ad", "dc"]
}

module "vm_sv1" {
  source       = "../modules/proxmox_vm"
  target_node  = var.primary_node
  vmid         = 401
  name         = "sv1"
  description  = "Windows Server 2016"
  cores        = 2
  memory       = 3072
  balloon      = 2048
  disk_size    = 50
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["ad", "server"]
}


module "client" {
  source       = "../modules/proxmox_vm"
  target_node  = var.primary_node
  vmid         = 402
  name         = "client"
  description  = "Windows 10"
  cores        = 2
  memory       = 3072
  balloon      = 2048
  disk_size    = 50
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "adwin10", "client", "domain-client", "microsoft", "terraform", "windows10"]
}
