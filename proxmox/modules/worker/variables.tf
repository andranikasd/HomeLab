variable "proxmox_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "worker_nodes" {
  description = "List of worker nodes"
  type = list(object({
    name      = string
    cores     = number
    memory    = number
    disk_size = number
    vmid      = number
    network   = string
  }))
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
}
