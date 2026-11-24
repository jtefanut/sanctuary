module "vm_opnsense" {
  source       = "../modules/proxmox_vm"
  target_node  = var.primary_node
  vmid         = 200
  name         = "opnsense-firewall"
  description  = "Perimeter Security Gateway, WireGuard VPN & Suricata/Snort DPI"
  cores        = 2
  memory       = 2048
  balloon      = 1024
  disk_size    = 16
  storage_pool = "local-lvm"
  vlan_tag     = 10
  tags         = ["network", "firewall", "ids-ips", "terraform"]
}


