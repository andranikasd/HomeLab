variable "proxmox_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "master_vmid_start" {
  description = "Starting VMID for master nodes"
  type        = number
  default     = 100
}

variable "worker_vmid_start" {
  description = "Starting VMID for worker nodes"
  type        = number
  default     = 200
}

variable "master_cores" {
  description = "CPU cores for master nodes"
  type        = number
  default     = 4
}

variable "worker_cores" {
  description = "CPU cores for worker nodes"
  type        = number
  default     = 2
}

variable "master_memory" {
  description = "Memory for master nodes (MB)"
  type        = number
  default     = 8192
}

variable "worker_memory" {
  description = "Memory for worker nodes (MB)"
  type        = number
  default     = 4096
}

variable "master_disk_size" {
  description = "Disk size for master nodes (GB)"
  type        = number
  default     = 50
}

variable "worker_disk_size" {
  description = "Disk size for worker nodes (GB)"
  type        = number
  default     = 50
}

variable "storage" {
  description = "Storage location for VMs"
  type        = string
}

variable "disk_type" {
  description = "Disk type (e.g., 'scsi', 'virtio')"
  type        = string
  default     = "scsi"
}

variable "network_model" {
  description = "Network model for VMs (e.g., 'virtio')"
  type        = string
  default     = "virtio"
}

variable "master_network" {
  description = "Network bridge for master nodes"
  type        = string
}

variable "worker_network" {
  description = "Network bridge for worker nodes"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "cloud_init_user" {
  description = "Default user for cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "template_name" {
  description = "Cloud-init template name"
  type        = string
}

variable "full_clone" {
  description = "Whether to create a full clone of the template"
  type        = bool
  default     = true
}

variable "cicustom" {
  description = "Cloud-Init custom configuration file path"
  type        = string
  default     = "vendor=local:snippets/qemu-guest-agent.yml"
}

variable "automatic_reboot" {
  description = "Automatically reboot the VM after parameter changes"
  type        = bool
  default     = true
}