module "lxc_homeassistant" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 900
  hostname     = "homeassistant"
  ostemplate   = var.debian_template
  ostype       = "debian"
  cores        = 2
  memory       = 384
  disk_size    = "16G"
  ip_address   = "10.10.10.11/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["automation", "iot", "smart-home", "zigbee", "terraform", "example-node"]
}


module "lxc_monitoring" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 901
  hostname     = "monitoring"
  ostemplate   = var.alpine_template
  ostype       = "alpine"
  cores        = 1
  memory       = 256
  disk_size    = "4G"
  ip_address   = "10.10.10.14/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["monitoring", "prometheus", "grafana", "terraform", "example-node"]
}


module "lxc_wazuh" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 902
  hostname     = "wazuh"
  ostemplate   = var.debian_template
  ostype       = "ubuntu"
  cores        = 4
  memory       = 6144
  disk_size    = "35G"
  ip_address   = "10.10.10.16/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["cyber", "siem", "xdr", "wazuh", "terraform", "example-node"]
}


module "lxc_mosquitto" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 903
  hostname     = "mosquitto"
  ostemplate   = var.debian_template
  ostype       = "debian"
  cores        = 2
  memory       = 1024
  disk_size    = "35G"
  ip_address   = "10.10.10.16/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["iot"]
}


module "lxc_esphome" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 904
  hostname     = "esphome"
  ostemplate   = var.debian_template
  ostype       = "debian"
  cores        = 2
  memory       = 1024
  disk_size    = "35G"
  ip_address   = "10.10.10.16/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["iot"]
}

