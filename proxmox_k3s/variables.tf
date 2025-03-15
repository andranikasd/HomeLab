# ────────────────────────────────────────────────────────────
# 🛠️ Proxmox API Connection Details
# ────────────────────────────────────────────────────────────
variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox user"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox user password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node to deploy on"
  type        = string
}

# ────────────────────────────────────────────────────────────
# 🏰 Bastion Host Configuration
# 
variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
}

variable "bastion_cores" {
  description = "Number of CPU cores for Bastion"
  type        = number
  default     = 2
}

variable "bastion_sockets" {
  description = "Bastion VM Sockets"
  type        = number
  default     = 1
}

variable "bastion_cpu_type" {
  description = "Bastion CPU Type"
  type        = string
  default     = "host"
}

variable "bastion_memory" {
  description = "Bastion Memory size (MB)"
  type        = number
  default     = 2048
}

variable "bastion_disk_size" {
  description = "Disk size for Bastion Host (GB)"
  type        = number
  default     = 20
}

variable "bastion_vmid_start" {
  description = "Bastion VM ID start"
  type        = number
  default     = 500
}

variable "bastion_storage" {
  description = "Storage location for Bastion"
  type        = string
}

variable "bastion_public_bridge" {
  description = "Public bridge for Bastion (e.g., vmbr0)"
  type        = string
  default     = "vmbr0"
}

variable "bastion_private_bridge" {
  description = "Private bridge for Bastion (e.g., vmbr1)"
  type        = string
  default     = "vmbr1"
}

variable "bastion_public_ip" {
  description = "Bastion public IP"
  type        = string
}

variable "bastion_private_ip" {
  description = "Bastion private IP"
  type        = string
}

variable "bastion_public_gateway" {
  description = "Bastion public gateway"
  type        = string
}

variable "bastion_private_gateway" {
  description = "Bastion private gateway"
  type        = string
}

# ────────────────────────────────────────────────────────────
# 🖥️ Master Node Configuration
# ────────────────────────────────────────────────────────────
variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 1
}

variable "master_vmid_start" {
  description = "Starting VMID for master nodes"
  type        = number
  default     = 100
}

variable "master_cores" {
  description = "CPU cores for master nodes"
  type        = number
  default     = 4
}

variable "master_sockets" {
  description = "Sockets for master nodes"
  type        = number
  default     = 1
}

variable "master_cpu_type" {
  description = "CPU type for master nodes"
  type        = string
  default     = "host"
}

variable "master_memory" {
  description = "Memory for master nodes (MB)"
  type        = number
  default     = 8192
}

variable "master_disk_size" {
  description = "Disk size for master nodes (GB)"
  type        = number
  default     = 50
}

variable "master_storage" {
  description = "Storage for master nodes"
  type        = string
}

variable "master_private_bridge" {
  description = "Private bridge for master nodes"
  type        = string
  default     = "vmbr1"
}

variable "master_ips" {
  description = "List of static IPs for master nodes"
  type        = list(string)
}

variable "master_private_gateway" {
  description = "Private gateway for master nodes"
  type        = string
}

# ────────────────────────────────────────────────────────────
# ⚙️ Worker Node Configuration
# ────────────────────────────────────────────────────────────
variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

variable "worker_vmid_start" {
  description = "Starting VMID for worker nodes"
  type        = number
  default     = 200
}

variable "worker_cores" {
  description = "CPU cores for worker nodes"
  type        = number
  default     = 2
}

variable "worker_sockets" {
  description = "Sockets for worker nodes"
  type        = number
  default     = 1
}

variable "worker_cpu_type" {
  description = "CPU type for worker nodes"
  type        = string
  default     = "host"
}

variable "worker_memory" {
  description = "Memory for worker nodes (MB)"
  type        = number
  default     = 4096
}

variable "worker_disk_size" {
  description = "Disk size for worker nodes (GB)"
  type        = number
  default     = 50
}

variable "worker_storage" {
  description = "Storage for worker nodes"
  type        = string
}

variable "worker_private_bridge" {
  description = "Private bridge for worker nodes"
  type        = string
  default     = "vmbr1"
}

variable "worker_ips" {
  description = "List of static IPs for worker nodes"
  type        = list(string)
}

variable "worker_private_gateway" {
  description = "Private gateway for worker nodes"
  type        = string
}

# ────────────────────────────────────────────────────────────
# 🔑 Cloud-Init and Storage Configuration
# ────────────────────────────────────────────────────────────
variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
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

variable "network_model" {
  description = "Network model for the VM"
  type        = string
  default     = "virtio"
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
