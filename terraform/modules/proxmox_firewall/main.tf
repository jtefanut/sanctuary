# Firewall policy design metadata only. This module does not push rules to
# Proxmox or OPNsense; apply and validate policy on the target appliance.
terraform {
  required_version = ">= 1.8.0"
}

variable "cluster_firewall_enabled" {
  type        = bool
  default     = true
  description = "Intended cluster firewall state (metadata only)"
}

variable "default_inbound_policy" {
  type        = string
  default     = "DROP"
  description = "Intended default ingress policy"
}

variable "default_outbound_policy" {
  type        = string
  default     = "ACCEPT"
  description = "Intended default egress policy"
}

variable "ipsets" {
  type = map(list(string))
  default = {
    "management-bastions" = [
      "10.10.10.0/24",
      "100.64.0.0/10"
    ]
    "cluster-nodes" = [
      "10.10.10.20",
      "10.10.10.21",
      "10.10.10.22",
      "10.10.10.23",
      "10.10.10.24"
    ]
    "cloud-tunnel-endpoints" = [
      "10.30.0.0/16",
      "10.200.0.0/16",
      "10.50.0.0/24"
    ]
    "telemetry-collectors" = [
      "10.10.10.20",
      "10.10.10.22"
    ]
    "bogon-networks" = [
      "0.0.0.0/8",
      "127.0.0.0/8",
      "169.254.0.0/16",
      "192.0.2.0/24",
      "198.51.100.0/24",
      "203.0.113.0/24",
      "224.0.0.0/4",
      "240.0.0.0/4"
    ]
  }
  description = "Planned IP sets for the firewall policy"
}

variable "security_groups" {
  type = map(object({
    comment = string
    rules   = list(map(string))
  }))
  default = {
    "mgmt" = {
      comment = "Proxmox management and bastion access"
      rules = [
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "8006", source = "+management-bastions", comment = "PVE WebGUI" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "22", source = "+management-bastions", comment = "SSH bastion" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "3121", source = "+management-bastions", comment = "SPICE proxy" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "85", source = "+management-bastions", comment = "Web console" }
      ]
    }
    "cluster" = {
      comment = "Cluster synchronization and migration"
      rules = [
        { type = "in", action = "ACCEPT", proto = "udp", dport = "5404:5405", source = "+cluster-nodes", comment = "Corosync" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "22,8006", source = "+cluster-nodes", comment = "Node API and SSH" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "60000:60050", source = "+cluster-nodes", comment = "Live migration" }
      ]
    }
    "telemetry" = {
      comment = "Metrics and log telemetry"
      rules = [
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "9100", source = "+telemetry-collectors", comment = "Node exporter" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "9256", source = "+telemetry-collectors", comment = "Process exporter" },
        { type = "in", action = "ACCEPT", proto = "tcp", dport = "3100", source = "+telemetry-collectors", comment = "Loki ingestion" }
      ]
    }
    "cloud" = {
      comment = "Hybrid cloud tunnels"
      rules = [
        { type = "in", action = "ACCEPT", proto = "udp", dport = "51820", source = "+cloud-tunnel-endpoints", comment = "WireGuard" },
        { type = "in", action = "ACCEPT", proto = "udp", dport = "500,4500", source = "+cloud-tunnel-endpoints", comment = "IPsec IKEv2 and NAT-T" }
      ]
    }
    "threat" = {
      comment = "Bogon filtering"
      rules = [
        { type = "in", action = "DROP", source = "+bogon-networks", log = "info", comment = "Drop bogon ranges" }
      ]
    }
  }
  description = "Planned firewall security groups"
}

output "firewall_status" {
  value = {
    enabled         = var.cluster_firewall_enabled
    policy_inbound  = var.default_inbound_policy
    policy_outbound = var.default_outbound_policy
    ipsets_count    = length(keys(var.ipsets))
    secgroups_count = length(keys(var.security_groups))
  }
}
