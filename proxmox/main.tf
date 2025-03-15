module "masters" {
  source = "./modules/vm"

  node_count       = var.master_count
  proxmox_node     = var.proxmox_node
  vm_name_prefix   = "k3s-master"
  template_name    = var.template_name
  full_clone       = var.full_clone
  vmid_start       = var.master_vmid_start
  cores            = var.master_cores
  memory           = var.master_memory
  disk_size        = var.master_disk_size
  storage          = var.storage
  disk_type        = var.disk_type
  network_model    = var.network_model
  network_bridge   = var.master_network
  ssh_public_key   = var.ssh_public_key
  cloud_init_user  = var.cloud_init_user
  cicustom         = "vendor=local:snippets/qemu-guest-agent.yml"
  automatic_reboot = true
}

module "workers" {
  source = "./modules/vm"

  node_count       = var.worker_count
  proxmox_node     = var.proxmox_node
  vm_name_prefix   = "k3s-worker"
  template_name    = var.template_name
  full_clone       = var.full_clone
  vmid_start       = var.worker_vmid_start
  cores            = var.worker_cores
  memory           = var.worker_memory
  disk_size        = var.worker_disk_size
  storage          = var.storage
  disk_type        = var.disk_type
  network_model    = var.network_model
  network_bridge   = var.worker_network
  ssh_public_key   = var.ssh_public_key
  cloud_init_user  = var.cloud_init_user
  cicustom         = "vendor=local:snippets/qemu-guest-agent.yml"
  automatic_reboot = true
}