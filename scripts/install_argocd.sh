#!/bin/bash
# install_argocd.sh
# This script installs ArgoCD on a Kubernetes cluster (e.g. k3s) and deploys an ArgoCD Application
# using a YAML configuration file (e.g. config/argocd-base.yaml) to deploy your project.
#
# Usage:
#   ./install_argocd.sh -c path/to/argocd-base.yaml
#
# Requirements: kubectl, argocd CLI, jq, curl

set -euo pipefail

usage() {
  echo "Usage: $0 -c <argo_application_yaml_file>"
  exit 1
}

# Install argocd CLI if it's not available
if ! command -v argocd &> /dev/null; then
  echo "argocd CLI not found. Installing argocd CLI..."
  ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  curl -sSL -o /tmp/argocd https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64
  chmod +x /tmp/argocd
  sudo mv /tmp/argocd /usr/local/bin/argocd
  echo "argocd CLI installed. Version:"
  argocd version --client
fi

# Check for required commands
for cmd in kubectl argocd jq curl; do
  if ! command -v "${cmd}" &> /dev/null; then
    echo "Error: ${cmd} is not installed or not in PATH."
    exit 1
  fi
done

# Parse arguments
while getopts ":c:" opt; do
  case ${opt} in
    c)
      APP_CONFIG=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done

if [[ -z "${APP_CONFIG:-}" ]] || [[ ! -f "${APP_CONFIG}" ]]; then
  echo "Error: ArgoCD Application YAML file not specified or does not exist."
  usage
fi

echo "=== Installing ArgoCD ==="
# Create the argocd namespace if it doesn't exist
kubectl create namespace argocd 2>/dev/null || echo "Namespace 'argocd' already exists."

# Install ArgoCD via the official manifest
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for the argocd-server deployment to be ready..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=180s

echo "Setting up temporary port-forward to the ArgoCD server (localhost:8080 -> svc/argocd-server:443)..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 >/dev/null 2>&1 &
PF_PID=$!

# Give port-forward a few seconds to establish
sleep 5

# Retrieve the initial admin password from the secret
ADMIN_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d)

echo "Logging into ArgoCD..."
# Log in via argocd CLI (using --insecure since we are port-forwarding)
argocd login localhost:8080 --username admin --password "${ADMIN_PASSWORD}" --insecure

echo "=== Deploying ArgoCD Application from manifest: ${APP_CONFIG} ==="
# Apply the ArgoCD Application manifest to create the Application resource
kubectl apply -f "${APP_CONFIG}"

# Optionally, you can trigger a sync using argocd CLI if the manifest doesn't auto-sync
# For example, if your Application metadata.name is "my-app":
# argocd app sync my-app --insecure

echo "Cleaning up port-forward..."
kill "${PF_PID}"

echo "ArgoCD installation and Application deployment complete."
