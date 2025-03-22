output "bastion_vm_details" {
  description = "Details of the provisioned Bastion Host"
  value = module.bastion.vm_details
}

# output "master_vm_details" {
#   description = "Details of the provisioned Master VMs"
#   value       = module.masters.vm_details
# }

# output "worker_vm_details" {
#   description = "Details of the provisioned Worker VMs"
#   value       = module.workers.vm_details
# }

