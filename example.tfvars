proxmox_node = "proxmox"

master_name    = "k8s-master"
master_vmid    = 100
master_cores   = 4
master_memory  = 8192
master_disk_size = 100
master_network = "vmbr0"

worker_nodes = [
  {
    name      = "k8s-worker-1"
    cores     = 2
    memory    = 4096
    disk_size = 150
    vmid      = 101
    network   = "vmbr0"
  },
  {
    name      = "k8s-worker-2"
    cores     = 2
    memory    = 4096
    disk_size = 150
    vmid      = 102
    network   = "vmbr0"
  },
  {
    name      = "k8s-worker-3"
    cores     = 2
    memory    = 4096
    disk_size = 150
    vmid      = 103
    network   = "vmbr0"
  }
]

ssh_public_key = "YOUR_SSH_PUBLIC_KEY_HERE"
