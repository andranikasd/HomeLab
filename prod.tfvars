# ----------------------------
# ✅ Proxmox API Connection
# ----------------------------
proxmox_api_url    = "https://datacenter.andranik.me/api2/json"
proxmox_user       = "root@pam"
proxmox_password   = "fartuna"

# ----------------------------
# ✅ Proxmox Node Settings
# ----------------------------
proxmox_node = "pve"

# ----------------------------
# ✅ Bastion Host Configuration (Public & Private)
# ----------------------------
bastion_public_ip = "10.0.0.30/24"
bastion_private_ip = "192.168.100.10/24"
bastion_public_gateway = "10.0.0.1"
bastion_private_gateway = "192.168.100.1"
bastion_cores = 2
bastion_cpu_type = "host"
bastion_disk_size = 20
bastion_memory = 2024
bastion_private_bridge = "vmbr1"
bastion_public_bridge = "vmbr0"
bastion_sockets = 2
bastion_storage = "ZFS_DEFAULT"
bastion_vmid_start = 500


# ----------------------------
# ✅ Master Nodes Configuration
# ----------------------------
master_count      = 1
master_vmid_start = 100
master_cores      = 2
master_memory     = 4096
master_disk_size  = 50
master_storage    = "ZFS_DEFAULT"

# 🔹 Private Network for Masters
master_private_bridge  = "vmbr1"
master_ips            = ["192.168.100.100/24"]
master_private_gateway = "192.168.100.1"

# ----------------------------
# ✅ Worker Nodes Configuration
# ----------------------------
worker_count      = 3
worker_vmid_start = 101
worker_cores      = 6
worker_memory     = 8192
worker_disk_size  = 150
worker_storage    = "ZFS_DEFAULT"

# 🔹 Private Network for Workers
worker_private_bridge  = "vmbr1"
worker_ips            = [
  "192.168.100.101/24",
  "192.168.100.102/24",
  "192.168.100.103/24"
]
worker_private_gateway = "192.168.100.1"

# ----------------------------
# ✅ Shared Configuration
# ----------------------------
ssh_public_key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqp+F+U+EqXmfP2jS8KZJL4ROi31XajUIMhdUhTaHWE andranik@hp-laptop"
private_key_path = "/home/andranik/.ssh/id_ed25519"
template_name    = "ubuntu-2404"
full_clone       = true
network_model    = "virtio"
cloud_init_user  = "ubuntu"
cloud_init_password = "fartuna"
