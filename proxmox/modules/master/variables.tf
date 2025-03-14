variable "proxmox_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "master_name" {
  description = "Master node name"
  type        = string
}

variable "master_vmid" {
  description = "Master node VM ID"
  type        = number
}

variable "master_cores" {
  description = "Master node CPU cores"
  type        = number
}

variable "master_memory" {
  description = "Master node memory in MB"
  type        = number
}

variable "master_disk_size" {
  description = "Master node disk size in GB"
  type        = number
}

variable "master_network" {
  description = "Network bridge for master node"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
}
