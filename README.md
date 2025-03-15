# 🏠 HomeLab - Automated Kubernetes Cluster on Proxmox

HomeLab is an **automated deployment** of a Kubernetes (K3s) cluster running on **Proxmox VMs**.
This project leverages **Infrastructure as Code (IaC)** principles using:
- **Terraform** 🏗️ → Provisions Proxmox VMs for Kubernetes nodes.
- **Ansible** ⚙️ → Configures the VMs and sets up a K3s cluster with essential applications.

## 🚀 Features
- Automated **Proxmox VM provisioning** using Terraform.
- Secure **K3s cluster setup** with Ansible.
- Default tools installed: **Cilium, NGINX Ingress, Longhorn, ArgoCD, Cloudflare Tunnel** (coming soon).
- Designed for **homelab environments** and **self-hosted deployments**.

---

## 📖 Getting Started
### **Prerequisites**
Ensure you have the following installed on your machine:
- 🏗️ **Terraform** (`>= 1.3.0`)
- ⚙️ **Ansible** (`>= 2.10`)
- ☁️ **Proxmox VE** (with Cloud-Init templates)
- 🖥️ **SSH Access** to Proxmox
