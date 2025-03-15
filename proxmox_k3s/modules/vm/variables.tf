variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
}

variable "proxmox_node" {
  description = "The Proxmox node where VMs will be deployed"
  type        = string
}

variable "vmid_start" {
  description = "Starting VM ID"
  type        = number
}

variable "template_name" {
  description = "Proxmox VM Template Name"
  type        = string
}

variable "full_clone" {
  description = "Whether to use a full clone"
  type        = bool
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
}

variable "memory" {
  description = "Amount of RAM (MB)"
  type        = number
}

variable "cpu_type" {
  description = "CPU type"
  type        = string
}

variable "numa" {
  description = "Enable NUMA"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
}

variable "storage" {
  description = "Proxmox storage pool"
  type        = string
}

variable "network_bridge" {
  description = "Primary network bridge"
  type        = string
}

variable "network_model" {
  description = "Network adapter model"
  type        = string
}

variable "network_mtu" {
  description = "MTU size for network"
  type        = number
  default     = 1500
}

variable "secondary_network_bridge" {
  description = "Optional secondary network bridge (for Bastion)"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "List of IP addresses"
  type        = list(string)
}

variable "gateway" {
  description = "Default gateway"
  type        = string
}

variable "secondary_ip" {
  description = "IP for secondary network (if applicable)"
  type        = string
  default     = ""
}

variable "secondary_gateway" {
  description = "Gateway for secondary network (if applicable)"
  type        = string
  default     = ""
}

variable "cloud_init_user" {
  description = "Cloud-Init username"
  type        = string
}

variable "cloud_init_password" {
  description = "Cloud-Init password"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for Cloud-Init"
  type        = string
}

variable "bastion_dependency" {
  description = "Ensures Bastion deploys first"
  type        = any
  default     = null
}
