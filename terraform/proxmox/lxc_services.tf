# ==============================================================================
# PROXMOX CORE LXC CONTAINERS (generic x86_64 node)
# Example Containers: 900 to 906
# ==============================================================================

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

module "lxc_scrutiny" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 901
  hostname     = "scrutiny"
  ostemplate   = var.debian_template
  ostype       = "debian"
  cores        = 1
  memory       = 128
  disk_size    = "4G"
  ip_address   = "10.10.10.12/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["monitoring", "smart", "storage", "telemetry", "terraform", "example-node"]
}

module "lxc_ollama" {
  source                 = "../modules/proxmox_lxc"
  target_node            = var.primary_node
  vmid = 902
  hostname               = "ollama"
  ostemplate             = var.debian_template
  ostype                 = "debian"
  cores                  = 4
  memory                 = 2048
  disk_size              = "16G"
  ip_address             = "10.10.10.10/24"
  gateway                = var.gateway_ip
  nameserver             = var.nameserver_ip
  vlan_tag               = 20
  unprivileged           = false
  passthrough_nvidia_gpu = true
  tags                   = ["ai", "llm", "cuda", "gtx1050ti", "local-ai", "terraform", "example-node"]
}

module "lxc_uptimekuma" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 903
  hostname     = "uptimekuma"
  ostemplate   = var.alpine_template
  ostype       = "alpine"
  cores        = 1
  memory       = 128
  disk_size    = "2G"
  ip_address   = "10.10.10.13/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["monitoring", "uptime", "status", "terraform", "example-node"]
}

module "lxc_monitoring" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 904
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

module "lxc_owasp" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 905
  hostname     = "owasp"
  ostemplate   = var.alpine_template
  ostype       = "alpine"
  cores        = 2
  memory       = 512
  disk_size    = "8G"
  ip_address   = "10.10.10.15/24"
  gateway      = var.gateway_ip
  nameserver   = var.nameserver_ip
  vlan_tag     = 20
  unprivileged = true
  tags         = ["cyber", "owasp", "pentest", "security", "terraform", "example-node"]
}

module "lxc_wazuh" {
  source       = "../modules/proxmox_lxc"
  target_node  = var.primary_node
  vmid = 906
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
