# ==============================================================================
# ACTIVE DIRECTORY LAB INFRASTRUCTURE (EXAMPLE FLEET 940 - 950)
# Multi-Generation Active Directory Enterprise Laboratory
# Windows Server 2025, 2022, 2019, 2016, 2012 R2, 2008 R2, 2003 R2, Win 7, Win 10, Win 11, RHEL 9.8
# Provider: bpg/proxmox (Proxmox VE REST API)
# Node: Node 1 (x86_64)
# ==============================================================================

# Example VM 940: Windows Server 2025 Standard/Datacenter Domain Controller
module "vm_ad2025" {
  source                 = "./modules/proxmox_vm"
  target_node            = var.primary_node
  vmid = 940
  name                   = "ad2025"
  description            = "Active Directory Lab - Windows Server 2025 Domain Controller (example GPU passthrough)"
  cores                  = 6
  memory                 = 8192
  balloon                = 4096
  disk_size              = 256
  storage_pool           = "local-lvm"
  pci_passthrough_device = "example-gpu"
  onboot                 = false
  tags                   = ["active-directory", "ad2025", "domain-controller", "example-gpu", "microsoft", "server2025", "terraform", "windows"]
}

# Example VM 941: Windows Server 2022 Standard/Datacenter Domain Controller
module "vm_ad2022" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 941
  name         = "ad2022"
  description  = "Active Directory Lab - Windows Server 2022 Domain Controller"
  cores        = 2
  memory       = 4096
  balloon      = 2048
  disk_size    = 60
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "ad2022", "domain-controller", "microsoft", "server2022", "terraform", "windows"]
}

# Example VM 942: Windows Server 2019 Standard Domain Controller
module "vm_ad2019" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 942
  name         = "ad2019"
  description  = "Active Directory Lab - Windows Server 2019 Domain Controller"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 128
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "ad2019", "domain-controller", "microsoft", "server2019", "terraform", "windows"]
}

# Example VM 943: Windows Server 2016 Standard Domain Controller
module "vm_ad2016" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 943
  name         = "ad2016"
  description  = "Active Directory Lab - Windows Server 2016 Domain Controller"
  cores        = 2
  memory       = 3072
  balloon      = 2048
  disk_size    = 50
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "ad2016", "domain-controller", "microsoft", "server2016", "terraform", "windows"]
}

# Example VM 944: Windows Server 2012 R2 Standard Domain Controller
module "vm_ad2012" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 944
  name         = "ad2012"
  description  = "Active Directory Lab - Windows Server 2012 R2 Domain Controller"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 40
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "ad2012", "domain-controller", "microsoft", "server2012r2", "terraform", "windows"]
}

# Example VM 945: Windows Server 2008 R2 SP1 Standard Domain Controller
module "vm_ad2008" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 945
  name         = "ad2008"
  description  = "Active Directory Lab - Windows Server 2008 R2 SP1 Domain Controller"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 40
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "ad2008", "domain-controller", "microsoft", "server2008r2", "terraform", "windows"]
}

# Example VM 946: Windows 10 Enterprise Domain Member Client
module "vm_adwin10" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 946
  name         = "adwin10"
  description  = "Active Directory Lab - Windows 10 Enterprise Domain Member Client"
  cores        = 2
  memory       = 3072
  balloon      = 2048
  disk_size    = 50
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "adwin10", "client", "domain-client", "microsoft", "terraform", "windows10"]
}

# Example VM 947: Windows 11 Enterprise Domain Member Client
module "vm_adwin11" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 947
  name         = "adwin11"
  description  = "Active Directory Lab - Windows 11 Enterprise Domain Member Client"
  cores        = 2
  memory       = 4096
  balloon      = 2048
  disk_size    = 60
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "adwin11", "client", "domain-client", "microsoft", "terraform", "windows11"]
}

# Example VM 948: Windows 7 Ultimate SP1 Domain Member Client
module "vm_adwin7" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 948
  name         = "adwin7"
  description  = "Active Directory Lab - Windows 7 Ultimate SP1 Domain Member Client"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 50
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "adwin7", "client", "domain-client", "microsoft", "terraform", "windows7"]
}

# Example VM 949: Red Hat Enterprise Linux 9.8 Workload (Active Directory Integrated)
module "vm_adrhel" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 949
  name         = "adrhel"
  description  = "Active Directory Lab - Red Hat Enterprise Linux 9.8 Domain Workload (SSSD / Realm Join, Kerberos)"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 50
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "adrhel", "linux", "redhat", "rhel", "sssd", "terraform"]
}

# Example VM 950: Windows Server 2003 R2 SP2 Enterprise Domain Controller
module "vm_ad2003" {
  source       = "./modules/proxmox_vm"
  target_node  = var.primary_node
  vmid = 950
  name         = "ad2003"
  description  = "Active Directory Lab - Windows Server 2003 R2 SP2 Enterprise Domain Controller"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 40
  storage_pool = "local-lvm"
  onboot       = false
  tags         = ["active-directory", "ad2003", "domain-controller", "legacy", "microsoft", "server2003", "terraform"]
}

