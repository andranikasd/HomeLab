#!/bin/bash
set -euo pipefail

# Define a log file (optional – adjust as needed)
LOGFILE="/var/log/k3s_setup.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Starting k3s master setup ==="

echo "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing k3s with custom options (disabling servicelb, traefik, and flannel)..."
# Install k3s with desired options; run as root via sudo.
curl -sfL https://get.k3s.io | sudo INSTALL_K3S_EXEC="--disable=servicelb --disable=traefik --disable=flannel" sh -

echo "Setting KUBECONFIG environment variable..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Waiting for k3s cluster to be ready..."
# Wait until the Kubernetes API is reachable.
counter=0
max_wait=300  # maximum wait in seconds
while ! kubectl get nodes >/dev/null 2>&1; do
  echo "K3s cluster not ready yet... waiting 5 seconds..."
  sleep 5
  counter=$((counter + 5))
  if [ $counter -ge $max_wait ]; then
    echo "Timeout waiting for k3s cluster to be ready." >&2
    exit 1
  fi
done
echo "K3s cluster is ready!"

echo "Checking if helm is installed..."
if ! command -v helm >/dev/null 2>&1; then
    echo "Helm not found. Installing helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    echo "Helm is already installed."
fi

echo "Installing Cilium as the CNI..."
# Add Cilium's repository and update.
helm repo add cilium https://helm.cilium.io/
helm repo update
# Install Cilium in the kube-system namespace with parameters tuned for k3s.
helm install cilium cilium/cilium \
  --namespace kube-system \
  --set global.containerRuntime.integration="k3s" \
  --set global.nodeinit.enabled=true

kubectl taint node "$MASTER_NODE_NAME" node-role.kubernetes.io/master=:NoSchedule