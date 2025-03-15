variable "vm_count" {
  description = "Number of VMs to deploy"
  type        = number
  default     = 1
}

variable "proxmox_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "vmid_start" {
  description = "Starting VMID for VMs"
  type        = number
  default     = 100
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "vm"
}

variable "template_name" {
  description = "Cloud-Init template name"
  type        = string
}

variable "full_clone" {
  description = "Whether to create a full clone of the template"
  type        = bool
  default     = true
}

variable "cores" {
  description = "Number of CPU cores per VM"
  type        = number
  default     = 2
}

variable "sockets" {
  description = "Number of CPU sockets per VM"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 4096
}

variable "cpu_type" {
  description = "Type of CPU emulation"
  type        = string
  default     = "host"
}

variable "numa" {
  description = "Enable NUMA"
  type        = bool
  default     = false
}

variable "disk_size" {
  description = "Size of the primary disk in GB"
  type        = number
  default     = 50
}

variable "storage" {
  description = "Storage pool for the VM"
  type        = string
}

variable "network_bridge" {
  description = "Network bridge to use"
  type        = string
}

variable "network_model" {
  description = "Network model type"
  type        = string
  default     = "virtio"
}

variable "network_mtu" {
  description = "MTU setting for the network interface"
  type        = number
  default     = 1500
}

variable "ip_address" {
  description = "Static IP address for the VM"
  type        = string
}

variable "gateway" {
  description = "Default gateway for the VM"
  type        = string
}

variable "cloud_init_user" {
  description = "Cloud-Init user"
  type        = string
  default     = "ubuntu"
}

variable "cloud_init_password" {
  description = "Cloud-Init user password"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH Public Key for Cloud-Init"
  type        = string
}
