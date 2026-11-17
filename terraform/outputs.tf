# Public example outputs intentionally omit real IP addresses and VMIDs.
output "vm_inventory" {
  description = "Logical inventory of provisioned virtual machines"
  value = [
    "firewall",
    "cloud_controller",
    "vulnerability_testing",
    "honeypot",
    "security_monitoring",
    "malware_analysis"
  ]
}
