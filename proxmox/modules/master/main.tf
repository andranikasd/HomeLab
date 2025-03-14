terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9"
    }
  }
  required_version = "v1.11.2"
}

resource "proxmox_vm_qemu" "master" {
  name        = var.master_name
  target_node = var.proxmox_node

  vmid        = var.master_vmid
  cores       = var.master_cores
  memory      = var.master_memory
  disk {
    size    = "${var.master_disk_size}G"
    type    = "scsi"
    storage = "local-lvm"
  }

  network {
    bridge = var.master_network
    model  = "virtio"
  }

  os_type = "cloud-init"
  sshkeys = var.ssh_public_key
  ciuser  = "ubuntu"
}
