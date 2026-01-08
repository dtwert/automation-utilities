#!/bin/bash
# SSH key setup script
# Generate and configure SSH keys for accessing GitHub

KeyFile=~/.ssh/id_ed25519

set -e

echo "=== SSH Automation Setup ==="

# Ensure directory exists and configure permissions
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key if it doesn't exist
if [ ! -f "$KeyFile" ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "automation@$(hostname)" -f "$KeyFile" -N "" -q
else
    echo "SSH key already exists."
fi

# Start SSH agent if not already running
if ! pgrep -x ssh-agent > /dev/null; then
    echo "Starting ssh-agent..."
    eval "$(ssh-agent -s)" > /dev/null 2>&1
else
    echo "ssh-agent is already running."
fi

# Add SSH key to agent
echo "Adding key to agent..."
ssh-add "$KeyFile" 2> /dev/null || true

# Display public key
echo -e "\n=== Public SSH Key ==="
cat "$KeyFile".pub
echo -e "\n=== Next Steps ==="
echo "1. Copy this key into GitHub under Settings > SSH and GPG keys."
echo "2. Test the connection with: ssh -T git@github.com"