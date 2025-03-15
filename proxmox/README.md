## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | v1.11.2 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 2.9 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_master"></a> [master](#module\_master) | ./modules/master | n/a |
| <a name="module_workers"></a> [workers](#module\_workers) | ./modules/worker | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_master_cores"></a> [master\_cores](#input\_master\_cores) | Master node CPU cores | `number` | n/a | yes |
| <a name="input_master_disk_size"></a> [master\_disk\_size](#input\_master\_disk\_size) | Master node disk size in GB | `number` | n/a | yes |
| <a name="input_master_memory"></a> [master\_memory](#input\_master\_memory) | Master node memory in MB | `number` | n/a | yes |
| <a name="input_master_name"></a> [master\_name](#input\_master\_name) | Master node name | `string` | n/a | yes |
| <a name="input_master_network"></a> [master\_network](#input\_master\_network) | Network bridge for master node | `string` | n/a | yes |
| <a name="input_master_vmid"></a> [master\_vmid](#input\_master\_vmid) | Master node VM ID | `number` | n/a | yes |
| <a name="input_proxmox_api_url"></a> [proxmox\_api\_url](#input\_proxmox\_api\_url) | Proxmox API URL (e.g., https://192.168.1.100:8006/api2/json) | `string` | n/a | yes |
| <a name="input_proxmox_node"></a> [proxmox\_node](#input\_proxmox\_node) | Proxmox node to deploy on | `string` | n/a | yes |
| <a name="input_proxmox_password"></a> [proxmox\_password](#input\_proxmox\_password) | Proxmox API password | `string` | n/a | yes |
| <a name="input_proxmox_user"></a> [proxmox\_user](#input\_proxmox\_user) | Proxmox API user (e.g., root@pam) | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key for cloud-init | `string` | n/a | yes |
| <a name="input_worker_nodes"></a> [worker\_nodes](#input\_worker\_nodes) | List of worker nodes | <pre>list(object({<br/>    name      = string<br/>    cores     = number<br/>    memory    = number<br/>    disk_size = number<br/>    vmid      = number<br/>    network   = string<br/>  }))</pre> | n/a | yes |

## Outputs

No outputs.
