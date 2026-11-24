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

# VMID allocation: 900-905. Except OPNsense, these VM modules create blank disks
# until an OS ISO or imported disk image is supplied.
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

module "vm_openstack_201" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 901
  name = "openstack"
  description = "OpenStack private cloud controller and compute"
  cores = 2
  memory = 4096
  balloon = 2048
  disk_size = 32
  storage_pool = "local-lvm"
  vlan_tag = 20
  tags = ["openstack", "cloud", "iaas", "terraform"]
}

module "vm_metasploitable2_202" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 902
  name = "metasploitable2"
  description = "Intentionally vulnerable penetration-testing target"
  cores = 1
  memory = 512
  disk_size = 8
  storage_pool = "local-lvm"
  vlan_tag = 30
  tags = ["cyber", "metasploit", "penetration-testing", "terraform"]
}

module "vm_tpot_203" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 903
  name = "tpot-honeypot"
  description = "T-Pot multi-honeypot platform"
  cores = 4
  memory = 8192
  balloon = 4096
  disk_size = 60
  storage_pool = "local-lvm"
  vlan_tag = 40
  tags = ["cyber", "honeypot", "tpot", "terraform"]
}

module "vm_securityonion_204" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 904
  name = "securityonion"
  description = "Security Onion network security monitoring platform"
  cores = 4
  memory = 8192
  balloon = 4096
  disk_size = 50
  storage_pool = "local-lvm"
  vlan_tag = 30
  tags = ["blue-team", "security-onion", "siem", "terraform"]
}

module "vm_remnux_205" {
  source = "./modules/proxmox_vm"
  target_node = var.primary_node
  vmid = 905
  name = "remnux"
  description = "REMnux malware analysis and DFIR workstation"
  cores = 2
  memory = 4096
  balloon = 2048
  disk_size = 40
  storage_pool = "local-lvm"
  vlan_tag = 30
  tags = ["cyber", "dfir", "malware-analysis", "terraform"]
}

# LXC VMIDs 906-914. Shared services use VLAN 10; HA and IoT use VLAN 50.
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

module "lxc_scrutiny" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 907
  hostname = "scrutiny"
  ostemplate = var.debian_template
  ostype = "debian"
  cores = 1
  memory = 128
  disk_size = "4G"
  ip_address = "10.10.10.11/24"
  gateway = var.gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 10
  tags = ["monitoring", "smart", "storage", "terraform"]
}

module "lxc_ollama" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 908
  hostname = "ollama"
  ostemplate = var.debian_template
  ostype = "debian"
  cores = 4
  memory = 2048
  disk_size = "16G"
  ip_address = "10.10.10.12/24"
  gateway = var.gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 10
  unprivileged = false
  device_passthrough = var.nvidia_device_paths
  tags = ["ai", "llm", "local-ai", "terraform"]
}

module "lxc_uptimekuma" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 909
  hostname = "uptimekuma"
  ostemplate = var.alpine_template
  ostype = "alpine"
  cores = 1
  memory = 128
  disk_size = "2G"
  ip_address = "10.10.10.13/24"
  gateway = var.gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 10
  tags = ["monitoring", "uptime", "terraform"]
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

module "lxc_owasp" {
  source = "./modules/proxmox_lxc"
  target_node = var.primary_node
  vmid = 911
  hostname = "owasp"
  ostemplate = var.alpine_template
  ostype = "alpine"
  cores = 2
  memory = 512
  disk_size = "8G"
  ip_address = "10.10.10.15/24"
  gateway = var.gateway_ip
  nameserver = var.nameserver_ip
  ssh_public_keys = var.ssh_public_keys
  vlan_tag = 10
  tags = ["cyber", "owasp", "pentest", "terraform"]
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
