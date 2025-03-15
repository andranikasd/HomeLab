#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# setup_kubectl.sh
#
# This script installs kubectl (if not present) and configures it by fetching
# the kubeconfig from the k3s master node via SSH with sudo. It then updates the
# kubeconfig to replace any local API server endpoints with the master’s accessible IP.
#
# Usage: ./setup_kubectl.sh <MASTER_IP> <USER> <PRIVATE_KEY_PATH>
#
# This script is production-ready with logging, error checking, and a wait loop
# to ensure the Kubernetes API is reachable.
# -----------------------------------------------------------------------------

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <MASTER_IP> <USER> <PRIVATE_KEY_PATH>"
  exit 1
fi

MASTER_IP="$1"
USER="$2"
PRIVATE_KEY_PATH="$3"

LOGFILE="/var/log/setup_kubectl.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Starting kubectl setup at $(date) ==="

# Verify that required commands exist.
for cmd in ssh curl sed; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Required command '$cmd' not found. Please install it." >&2
    exit 1
  fi
done

echo "Checking if kubectl is installed..."
if ! command -v kubectl &>/dev/null; then
   echo "kubectl not found, installing..."
   KUBE_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
   echo "Latest stable kubectl version: ${KUBE_VERSION}"
   curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl"
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/kubectl
else
   echo "kubectl is already installed."
fi

if ! command -v kubectl &>/dev/null; then
   echo "Error: kubectl installation failed." >&2
   exit 1
fi

# Create a temporary workspace for the kubeconfig file.
TMP_DIR=$(mktemp -d)
KUBECONFIG_PATH="$/home/ubuntu/.kube/config"

echo "Fetching kubeconfig from master (${MASTER_IP})..."
# Use ssh with sudo to output the kubeconfig file.
ssh -o StrictHostKeyChecking=no -i "$PRIVATE_KEY_PATH" ${USER}@${MASTER_IP} "sudo cat /etc/rancher/k3s/k3s.yaml" > "${KUBECONFIG_PATH}"
if [ ! -s "${KUBECONFIG_PATH}" ]; then
    echo "Error: kubeconfig file not fetched or is empty." >&2
    exit 1
fi

echo "Updating kubeconfig to use the master IP..."
# Replace both possible local endpoints with the master IP.
sed -i "s|https://127.0.0.1:6443|https://${MASTER_IP}:6443|g" "${KUBECONFIG_PATH}"
sed -i "s|http://localhost:8080|https://${MASTER_IP}:6443|g" "${KUBECONFIG_PATH}"

echo "Setting KUBECONFIG environment variable to ${KUBECONFIG_PATH}..."
export KUBECONFIG="${KUBECONFIG_PATH}"

echo "Verifying kubectl connectivity to the cluster..."
counter=0
max_wait=60  # seconds
until kubectl get nodes &>/dev/null || [ $counter -ge $max_wait ]; do
    echo "Waiting for Kubernetes API to become available..."
    sleep 5
    counter=$((counter + 5))
done

if kubectl get nodes &>/dev/null; then
    echo "kubectl is now configured and the cluster is reachable."
    echo "You can test it with: kubectl get nodes"
else
    echo "Error: Kubernetes API not reachable after ${max_wait} seconds." >&2
    exit 1
fi

echo "=== kubectl setup complete at $(date) ==="