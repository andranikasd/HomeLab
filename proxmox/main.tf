module "master" {
  source         = "./modules/master"
  proxmox_node   = var.proxmox_node
  master_name    = var.master_name
  master_vmid    = var.master_vmid
  master_cores   = var.master_cores
  master_memory  = var.master_memory
  master_disk_size = var.master_disk_size
  master_network = var.master_network
  ssh_public_key = var.ssh_public_key
}

module "workers" {
  source         = "./modules/worker"
  proxmox_node   = var.proxmox_node
  worker_nodes   = var.worker_nodes
  ssh_public_key = var.ssh_public_key
}
