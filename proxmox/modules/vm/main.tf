terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">=3.0.1-rc4"
    }
  }
  required_version = ">= 1.3.0"
}

resource "proxmox_vm_qemu" "vm" {
  count       = var.vm_count
  name        = "${var.vm_name_prefix}-${count.index + 1}"
  target_node = var.proxmox_node
  vmid        = var.vmid_start + count.index
  agent       = 1
  desc        = "Managed by Terraform"

  clone       = var.template_name
  full_clone  = var.full_clone
  os_type     = "cloud-init"
  automatic_reboot = true
  onboot      = true
  vm_state    = "running"

  # CPU & Memory
  cores       = var.cores
  sockets     = var.sockets
  memory      = var.memory
  cpu         = var.cpu_type
  numa        = var.numa

  # Disks
  scsihw      = "virtio-scsi-single"
  bootdisk    = "virtio0"

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "${var.disk_size}G"
          storage = var.storage
          iothread = true
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = var.storage
        }
      }
    }
  }

  # Network
  network {
    bridge = var.network_bridge
    model  = var.network_model
    mtu    = var.network_mtu
  }

  # Cloud-Init Configuration
  ipconfig0 = "ip=${var.ip_address},gw=${var.gateway}"
  ciuser    = var.cloud_init_user
  cipassword = var.cloud_init_password
  sshkeys   = var.ssh_public_key

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
