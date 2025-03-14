# Base Proxmox connection variables
variable "proxmox_api_url" {
  description = "Proxmox API URL (e.g., https://192.168.1.100:8006/api2/json)"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox API user (e.g., root@pam)"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox API password"
  type        = string
  sensitive   = true
}


variable "proxmox_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

# Master Node Variables
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

# Worker Node Variables
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

# SSH Key
variable "ssh_public_key" {
  description = "SSH public key for cloud-init"
  type        = string
}
