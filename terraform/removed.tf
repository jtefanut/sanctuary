# These guests are no longer part of the active homelab inventory.
# Forget any stale Terraform state entries without issuing Proxmox deletions.
# This keeps state cleanup non-destructive even if stale entries remain.

removed {
  from = module.vm_openstack_201
  lifecycle { destroy = false }
}

removed {
  from = module.vm_metasploitable2_202
  lifecycle { destroy = false }
}

removed {
  from = module.vm_tpot_203
  lifecycle { destroy = false }
}

removed {
  from = module.vm_securityonion_204
  lifecycle { destroy = false }
}

removed {
  from = module.vm_remnux_205
  lifecycle { destroy = false }
}

removed {
  from = module.lxc_ollama
  lifecycle { destroy = false }
}

removed {
  from = module.lxc_scrutiny
  lifecycle { destroy = false }
}

removed {
  from = module.lxc_uptimekuma
  lifecycle { destroy = false }
}

removed {
  from = module.lxc_owasp
  lifecycle { destroy = false }
}

removed {
  from = module.vm_ad2025
  lifecycle { destroy = false }
}

removed {
  from = module.vm_ad2019
  lifecycle { destroy = false }
}

removed {
  from = module.vm_ad2012
  lifecycle { destroy = false }
}

removed {
  from = module.vm_ad2008
  lifecycle { destroy = false }
}

removed {
  from = module.vm_adwin11
  lifecycle { destroy = false }
}

removed {
  from = module.vm_adwin7
  lifecycle { destroy = false }
}

removed {
  from = module.vm_adrhel
  lifecycle { destroy = false }
}

removed {
  from = module.vm_ad2003
  lifecycle { destroy = false }
}
