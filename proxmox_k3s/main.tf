module "bastion" {
  source = "./modules/vm"

  vm_count            = 1
  proxmox_node        = var.proxmox_node
  vm_name_prefix      = "bastion"
  template_name       = var.template_name
  full_clone          = var.full_clone
  vmid_start          = var.bastion_vmid_start
  cores               = var.bastion_cores
  sockets             = var.bastion_sockets
  cpu_type            = var.bastion_cpu_type
  memory              = var.bastion_memory
  disk_size           = var.bastion_disk_size
  storage             = var.bastion_storage
  network_model       = var.network_model
  ssh_public_key      = var.ssh_public_key
  cloud_init_user     = var.cloud_init_user
  cloud_init_password = var.cloud_init_password

  # Primary Public Network (vmbr0)
  network_bridge = var.bastion_public_bridge
  ip_address     = [var.bastion_public_ip]  # Wrapped in a list
  gateway        = var.bastion_public_gateway

  # Secondary Private Network (vmbr1)
  secondary_network_bridge = var.bastion_private_bridge
  secondary_ip             = var.bastion_private_ip
  secondary_gateway        = var.bastion_private_gateway
}

module "masters" {
  source = "./modules/vm"

  vm_count            = var.master_count
  proxmox_node        = var.proxmox_node
  vm_name_prefix      = "k3s-master"
  template_name       = var.template_name
  full_clone          = var.full_clone
  vmid_start          = var.master_vmid_start
  cores               = var.master_cores
  sockets             = var.master_sockets
  cpu_type            = var.master_cpu_type
  memory              = var.master_memory
  disk_size           = var.master_disk_size
  storage             = var.master_storage
  network_model       = var.network_model
  ssh_public_key      = var.ssh_public_key
  cloud_init_user     = var.cloud_init_user
  cloud_init_password = var.cloud_init_password

  # Private Network (vmbr1)
  network_bridge = var.master_private_bridge
  ip_address     = var.master_ips   # Pass the full list
  gateway        = var.master_private_gateway
}

module "workers" {
  source = "./modules/vm"

  vm_count            = var.worker_count
  proxmox_node        = var.proxmox_node
  vm_name_prefix      = "k3s-worker"
  template_name       = var.template_name
  full_clone          = var.full_clone
  vmid_start          = var.worker_vmid_start
  cores               = var.worker_cores
  sockets             = var.worker_sockets
  cpu_type            = var.worker_cpu_type
  memory              = var.worker_memory
  disk_size           = var.worker_disk_size
  storage             = var.worker_storage
  network_model       = var.network_model
  ssh_public_key      = var.ssh_public_key
  cloud_init_user     = var.cloud_init_user
  cloud_init_password = var.cloud_init_password

  # 🔹 Private Network only (vmbr1)
  network_bridge      = var.worker_private_bridge
  ip_address         = var.worker_ips
  gateway            = var.worker_private_gateway
}


##############################
# k3s Installation Section
##############################
resource "null_resource" "install_k3s_master" {
  depends_on = [module.masters]
  
  # Copy the k3s master setup script via the bastion
  provisioner "file" {
    connection {
      host                = split("/", module.masters.vm_ips[0])[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    source      = "${path.module}/scripts/k3s_master_setup.sh"
    destination = "/home/${var.cloud_init_user}/k3s_master_setup.sh"
  }

  # Execute the script via the bastion
  provisioner "remote-exec" {
    connection {
      host                = split("/", module.masters.vm_ips[0])[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    inline = [
      "chmod +x /home/${var.cloud_init_user}/k3s_master_setup.sh",
      "sudo /home/${var.cloud_init_user}/k3s_master_setup.sh"
    ]
  }
}

data "external" "k3s_token" {
  depends_on = [null_resource.install_k3s_master]
  program = [
    "bash",
    "${path.module}/scripts/get_k3s_token.sh",
    split("/", module.masters.vm_ips[0])[0],
    var.cloud_init_user,
    var.private_key_path,
    split("/", module.bastion.vm_ips[0])[0]
  ]
}

locals {
  all_node_ips = concat(
    module.bastion.vm_ips,
    module.masters.vm_ips,
    module.workers.vm_ips
  )
}

resource "null_resource" "install_common" {
  count = length(local.all_node_ips)

  provisioner "file" {
    connection {
      host                = split("/", local.all_node_ips[count.index])[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    source      = "${path.module}/scripts/nodes_common.sh"
    destination = "/home/${var.cloud_init_user}/common.sh"
  }

  provisioner "remote-exec" {
    connection {
      host                = split("/", local.all_node_ips[count.index])[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    inline = [
      "chmod +x /home/${var.cloud_init_user}/common.sh",
      "sudo /home/${var.cloud_init_user}/common.sh"
    ]
  }
}

resource "null_resource" "install_k3s_workers" {
  count      = var.worker_count
  depends_on = [data.external.k3s_token]
  
  provisioner "remote-exec" {
    connection {
      host                = split("/", element(module.workers.vm_ips, count.index))[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    inline = [
      "curl -sfL https://get.k3s.io | K3S_URL=https://${split("/", module.masters.vm_ips[0])[0]}:6443 K3S_TOKEN=${data.external.k3s_token.result.token} sh -"
    ]
  }
}

resource "null_resource" "setup_kubectl_bastion" {
  depends_on = [
    module.bastion,
    module.masters,
    null_resource.install_k3s_workers  // Ensure cluster is up before fetching kubeconfig
  ]

  # Copy the setup script to bastion
  provisioner "file" {
    connection {
      host        = split("/", module.bastion.vm_ips[0])[0]
      user        = var.cloud_init_user
      private_key = file(var.private_key_path)
    }
    source      = "${path.module}/scripts/setup_kubectl.sh"
    destination = "/home/${var.cloud_init_user}/setup_kubectl.sh"
  }

  # Copy the SSH private key to bastion for use by the script
  provisioner "file" {
    connection {
      host        = split("/", module.bastion.vm_ips[0])[0]
      user        = var.cloud_init_user
      private_key = file(var.private_key_path)
    }
    source      = var.private_key_path
    destination = "/home/${var.cloud_init_user}/id_rsa_for_master"
  }

  # Execute the setup script on bastion
  provisioner "remote-exec" {
    connection {
      host        = split("/", module.bastion.vm_ips[0])[0]
      user        = var.cloud_init_user
      private_key = file(var.private_key_path)
    }
    inline = [
      "chmod +x /home/${var.cloud_init_user}/setup_kubectl.sh",
      "chmod 600 /home/${var.cloud_init_user}/id_rsa_for_master",
      "sudo /home/${var.cloud_init_user}/setup_kubectl.sh ${split("/", module.masters.vm_ips[0])[0]} ${var.cloud_init_user} /home/${var.cloud_init_user}/id_rsa_for_master"
    ]
  }
}


resource "null_resource" "install_nginx" {
  depends_on = [
    null_resource.setup_kubectl_bastion  // Ensure kubectl is set up and the cluster is ready
  ]
  
  # Copy the nginx post-install script to the master node
  provisioner "file" {
    connection {
      host                = split("/", module.masters.vm_ips[0])[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    source      = "${path.module}/scripts/nginx.sh"
    destination = "/home/${var.cloud_init_user}/post_install_nginx.sh"
  }

  # Execute the nginx post-install script on the master node
  provisioner "remote-exec" {
    connection {
      host                = split("/", module.masters.vm_ips[0])[0]
      user                = var.cloud_init_user
      private_key         = file(var.private_key_path)
      bastion_host        = split("/", module.bastion.vm_ips[0])[0]
      bastion_user        = var.cloud_init_user
      bastion_private_key = file(var.private_key_path)
    }
    inline = [
      "chmod +x /home/${var.cloud_init_user}/post_install_nginx.sh",
      "sudo /home/${var.cloud_init_user}/post_install_nginx.sh"
    ]
  }
}