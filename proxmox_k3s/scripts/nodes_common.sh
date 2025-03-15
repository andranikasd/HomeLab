#!/bin/bash
set -euo pipefail

echo "=== Starting common configuration ==="

# Update package list and upgrade existing packages
echo "Updating package list..."
sudo apt-get update -y
echo "Upgrading system packages..."
sudo apt-get upgrade -y

# Disable swap (Kubernetes requires swap to be off)
echo "Disabling swap..."
sudo swapoff -a
# Comment out swap entries in /etc/fstab to prevent swap from being re-enabled on boot
sudo sed -i.bak '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install essential packages
echo "Installing essential packages..."
sudo apt-get install -y nfs-common curl wget apt-transport-https ca-certificates software-properties-common

# Load required kernel modules for container runtimes and networking
echo "Loading necessary kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

# Persist kernel module loading across reboots
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Set sysctl params required for Kubernetes networking
echo "Configuring sysctl parameters for Kubernetes..."
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl settings without reboot
sudo sysctl --system

# Optionally, install additional common utilities if needed
echo "Installing additional utilities..."
sudo apt-get install -y vim git htop

echo "=== Common configuration complete! ==="
