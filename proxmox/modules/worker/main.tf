terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
  required_version = "v1.11.2"
}

resource "proxmox_vm_qemu" "worker" {
  count       = length(var.worker_nodes)
  name        = var.worker_nodes[count.index].name
  target_node = var.proxmox_node

  vmid        = var.worker_nodes[count.index].vmid
  cores       = var.worker_nodes[count.index].cores
  memory      = var.worker_nodes[count.index].memory
  disk {
    size    = "${var.worker_nodes[count.index].disk_size}G"
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    bridge = var.worker_nodes[count.index].network
    model  = "virtio"
  }

  os_type = "cloud-init"
  sshkeys = var.ssh_public_key
  ciuser  = "ubuntu"
}
