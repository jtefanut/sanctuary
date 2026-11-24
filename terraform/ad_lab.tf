# Isolated Active Directory practice fleet. These declarations create guest
# hardware only; OS installation, static addressing and domain promotion are
# separate configuration steps. Guest IDs 940-950 are reserved for this lab.

module "vm_ad2025" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 940
  name = "ad2025"
  description = "Active Directory lab - Windows Server 2025"
  cores = 6
  memory = 8192
  balloon = 4096
  disk_size = 256
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2025", "terraform", "windows"]
}

module "vm_ad2022" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 941
  name = "ad2022"
  description = "Active Directory lab - Windows Server 2022"
  cores = 2
  memory = 4096
  balloon = 2048
  disk_size = 60
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2022", "terraform", "windows"]
}

module "vm_ad2019" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 942
  name = "ad2019"
  description = "Active Directory lab - Windows Server 2019"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 128
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2019", "terraform", "windows"]
}

module "vm_ad2016" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 943
  name = "ad2016"
  description = "Active Directory lab - Windows Server 2016"
  cores = 2
  memory = 3072
  balloon = 2048
  disk_size = 50
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2016", "terraform", "windows"]
}

module "vm_ad2012" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 944
  name = "ad2012"
  description = "Active Directory lab - Windows Server 2012 R2"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 40
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2012r2", "terraform", "windows"]
}

module "vm_ad2008" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 945
  name = "ad2008"
  description = "Active Directory lab - Windows Server 2008 R2"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 40
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2008r2", "terraform", "windows"]
}

module "vm_adwin10" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 946
  name = "adwin10"
  description = "Active Directory lab - Windows 10 client"
  cores = 2
  memory = 3072
  balloon = 2048
  disk_size = 50
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "client", "windows10", "terraform"]
}

module "vm_adwin11" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 947
  name = "adwin11"
  description = "Active Directory lab - Windows 11 client"
  cores = 2
  memory = 4096
  balloon = 2048
  disk_size = 60
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "client", "windows11", "terraform"]
}

module "vm_adwin7" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 948
  name = "adwin7"
  description = "Active Directory lab - Windows 7 client"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 50
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "client", "windows7", "terraform"]
}

module "vm_adrhel" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 949
  name = "adrhel"
  description = "Active Directory lab - RHEL 9.8 domain member"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 50
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "linux", "rhel", "sssd", "terraform"]
}

module "vm_ad2003" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 950
  name = "ad2003"
  description = "Active Directory lab - Windows Server 2003 R2 legacy domain controller"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 40
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "legacy", "server2003", "terraform", "windows"]
}
