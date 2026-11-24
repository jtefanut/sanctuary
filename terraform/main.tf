# Homelab infrastructure - single active Terraform root.
# Run Terraform from this directory: terraform init && terraform validate.
# VLAN/network modules describe the intended topology; they do not configure
# switch trunks, OPNsense interfaces, DHCP, routing or Proxmox SDN resources.
# Shared infrastructure LXCs use VLAN 10; Home Assistant and IoT endpoints use VLAN 50.

module "vlan_10_mgmt" {
  source = "./modules/network_segment"
  vlan_id = 10
  name = "Management and shared services"
  cidr = "10.10.10.0/24"
  gateway = "10.10.10.1"
  default_firewall_policy = "PASS"
}

module "vlan_20_core" {
  source = "./modules/network_segment"
  vlan_id = 20
  name = "Core workloads"
  cidr = "10.10.20.0/24"
  gateway = "10.10.20.1"
  default_firewall_policy = "DROP"
}

module "vlan_30_cyber" {
  source = "./modules/network_segment"
  vlan_id = 30
  name = "Cyber range and malware analysis"
  cidr = "10.10.30.0/24"
  gateway = "10.10.30.1"
  default_firewall_policy = "DROP"
}

module "vlan_40_dmz" {
  source = "./modules/network_segment"
  vlan_id = 40
  name = "DMZ and honeypots"
  cidr = "10.10.40.0/24"
  gateway = "10.10.40.1"
  default_firewall_policy = "DROP"
}

module "vlan_50_iot" {
  source = "./modules/network_segment"
  vlan_id = 50
  name = "IoT and edge devices"
  cidr = "10.10.50.0/24"
  gateway = "10.10.50.1"
  default_firewall_policy = "DROP"
}

# Active VMID allocation: OPNsense 900 and Windows malware-analysis VM 931.
# Existing Windows guests retain their Terraform module addresses for state continuity.
module "vm_opnsense_200" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 900
  name = "opnsense"
  description = "OPNsense firewall and Suricata IDS/IPS"
  cores = 2
  memory = 2048
  balloon = 1024
  disk_size = 16
  storage_pool = "local-lvm"
  iso_file_id = "local:iso/OPNsense-dvd-amd64.iso"
  network_devices = [
    { bridge = "vmbr1", firewall = false, mac_address = "02:00:00:00:00:01" },
    { bridge = "vmbr0", firewall = false, mac_address = "02:00:00:00:00:02" },
    { bridge = "vmbr2", firewall = false, mac_address = "02:00:00:00:00:03" }
  ]
  os_type = "other"
  tags = ["firewall", "security", "opnsense", "suricata", "terraform"]
}

# Active LXC guests only: Home Assistant, Monitoring, Wazuh, Mosquitto and ESPHome.
module "vm_malware_analysis" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 931
  name = "malware-analysis"
  description = "Windows 10 malware analysis workstation"
  os_type = "win10"
  cores = 2
  memory = 2560
  balloon = 0
  disk_size = 50
  storage_pool = "local-lvm"
  network_devices = [
    { bridge = "vmbr0", firewall = true, mac_address = "02:00:00:00:00:07" }
  ]
  cpu_type = "x86-64-v2-AES"
  onboot = false
  tags = ["windows", "windows10", "malware-analysis", "sandbox", "terraform"]
}

module "lxc_homeassistant" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 906
  hostname = "homeassistant"
  ostemplate = var.debian_template
  ostype = "debian"
  cores = 2
  memory = 1024
  swap = 1024
  disk_size = "16G"
  ip_address = "10.10.50.10/24"
  gateway = var.iot_gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 50
  unprivileged = true
  tags = ["automation", "iot", "home-assistant", "terraform"]
}

module "lxc_monitoring" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 910
  hostname = "monitoring"
  ostemplate = var.alpine_template
  ostype = "alpine"
  cores = 1
  memory = 256
  swap = 128
  disk_size = "4G"
  ip_address = "10.10.10.14/24"
  gateway = var.gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 10
  unprivileged = true
  onboot = false
  tags = ["monitoring", "prometheus", "grafana", "terraform"]
}

module "lxc_wazuh" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 912
  hostname = "wazuh"
  ostemplate = var.debian_template
  ostype = "debian"
  cores = 4
  memory = 6144
  swap = 4096
  disk_size = "35G"
  ip_address = "10.10.10.16/24"
  gateway = var.gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 10
  unprivileged = true
  tags = ["cyber", "siem", "xdr", "wazuh", "terraform"]
}

module "lxc_mosquitto" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 913
  hostname = "mosquitto"
  ostemplate = var.alpine_template
  ostype = "alpine"
  cores = 1
  memory = 256
  swap = 128
  disk_size = "3G"
  ip_address = "10.10.50.17/24"
  gateway = var.iot_gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 50
  onboot = false
  tags = ["iot", "mqtt", "terraform"]
}

module "lxc_esphome" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 914
  hostname = "esphome"
  ostemplate = var.debian_template
  ostype = "debian"
  cores = 2
  memory = 1536
  disk_size = "30G"
  ip_address = "10.10.50.18/24"
  gateway = var.iot_gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 50
  unprivileged = false
  onboot = false
  device_passthrough = ["/dev/net/tun"]
  tags = ["iot", "esphome", "terraform"]
}

# These modules currently expose design metadata only; they do not create
# SDN zones, firewall rules or tunnels on the Proxmox/OPNsense appliances.
module "proxmox_sdn" {
  source = "./modules/proxmox_sdn"
}

module "proxmox_firewall" {
  source = "./modules/proxmox_firewall"
}

module "hybrid_tunnel" {
  source = "./modules/hybrid_tunnel"
}
