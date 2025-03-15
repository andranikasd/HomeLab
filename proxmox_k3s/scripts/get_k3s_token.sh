#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# get_k3s_token.sh
#
# This script retrieves the k3s node token from the k3s master node via a bastion proxy.
# It connects via SSH using the provided user, private key, and bastion IP,
# retrieves the token from /var/lib/rancher/k3s/server/node-token,
# and outputs it in JSON format.
#
# Usage: ./get_k3s_token.sh <MASTER_IP> <USER> <PRIVATE_KEY_PATH> <BASTION_IP>
# -----------------------------------------------------------------------------

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <MASTER_IP> <USER> <PRIVATE_KEY_PATH> <BASTION_IP>" >&2
    exit 1
fi

MASTER_IP="$1"
USER="$2"
PRIVATE_KEY_PATH="$3"
BASTION_IP="$4"

# Log messages are sent to stderr so they don't interfere with JSON output.
echo "Retrieving k3s node token from master (${MASTER_IP}) via bastion (${BASTION_IP})..." >&2

TOKEN=$(ssh -o BatchMode=yes \
           -o StrictHostKeyChecking=no \
           -i "$PRIVATE_KEY_PATH" \
           -o ProxyCommand="ssh -W %h:%p -q ${USER}@${BASTION_IP}" \
           ${USER}@${MASTER_IP} "sudo cat /var/lib/rancher/k3s/server/node-token")

if [ -z "$TOKEN" ]; then
    echo "Error: Token is empty or could not be retrieved." >&2
    exit 1
fi

# Output only the valid JSON on stdout.
echo "{\"token\": \"${TOKEN}\"}"
