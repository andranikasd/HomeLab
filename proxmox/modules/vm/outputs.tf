output "vm_details" {
  description = "Details of the provisioned VMs"
  value = [
    for i in range(var.vm_count) : {
      name        = proxmox_vm_qemu.vm[i].name
      vmid        = proxmox_vm_qemu.vm[i].vmid
      node        = proxmox_vm_qemu.vm[i].target_node
      ip_address  = var.ip_address
      cores       = proxmox_vm_qemu.vm[i].cores
      memory_mb   = proxmox_vm_qemu.vm[i].memory
      disk_size_gb = var.disk_size
      storage     = var.storage
    }
  ]
}

output "vm_names" {
  description = "List of VM names"
  value       = [for vm in proxmox_vm_qemu.vm : vm.name]
}

output "vm_ids" {
  description = "List of VM IDs"
  value       = [for vm in proxmox_vm_qemu.vm : vm.vmid]
}

output "vm_ips" {
  description = "List of assigned IP addresses"
  value       = [for _ in range(var.vm_count) : var.ip_address]
}
