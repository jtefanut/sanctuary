# Only the two installed Windows Server guests and the Windows 10 client remain.
# Existing module addresses and VMIDs are retained to avoid Terraform state churn.



module "vm_ad2022" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 941
  name = "dc"
  os_type = "win11"
  description = "Windows Server 2022 domain controller"
  cores = 2
  memory = 4096
  balloon = 2048
  disk_size = 60
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2022", "terraform", "windows"]
}



module "vm_ad2016" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 943
  name = "server1"
  os_type = "win10"
  description = "Windows Server 2016 member server"
  cores = 2
  memory = 3072
  balloon = 2048
  disk_size = 50
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "domain-controller", "server2016", "terraform", "windows"]
}





module "vm_adwin10" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 946
  name = "client"
  os_type = "win10"
  description = "Windows 10 domain client"
  cores = 2
  memory = 3072
  balloon = 2048
  disk_size = 50
  storage_pool = "local-lvm"
  onboot = false
  tags = ["active-directory", "client", "windows10", "terraform"]
}








