#!/bin/bash
set -euo pipefail

echo "Starting the post-installation setup..."

# Ensure kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Installing..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
else
    echo "kubectl already installed."
fi

# Installing Ingress NGINX using Helm
echo "Installing Ingress-NGINX..."

# Add the ingress-nginx Helm repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Create the namespace for Ingress NGINX
kubectl create namespace ingress-nginx

# Install Ingress NGINX in the ingress-nginx namespace
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --set controller.ingressClass=nginx \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.type=LoadBalancer

# Verify the installation
echo "Waiting for Ingress-NGINX controller to be ready..."
kubectl rollout status deployment/ingress-nginx-controller -n ingress-nginx