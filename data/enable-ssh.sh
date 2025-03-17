#!/bin/bash

# Script to enable SSH password authentication
# Improved version with error handling and verification

# Exit on error
set -e

# Config file path
SSH_CONFIG="/etc/ssh/sshd_config"
KEY="PasswordAuthentication"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Check if SSH config file exists
if [[ ! -f "$SSH_CONFIG" ]]; then
  echo "Error: SSH configuration file not found at $SSH_CONFIG"
  exit 1
fi

echo "====== SSH Password Authentication Setup ======"

# Check current setting
echo "Current configuration:"
if grep -q "^\s*$KEY no" "$SSH_CONFIG"; then
  echo "* Password authentication is currently disabled"

  echo -e "\nEnabling password authentication..."
  sed -i "s/^\s*$KEY no/$KEY yes/" "$SSH_CONFIG"

  # Verify the change
  if grep -q "^\s*$KEY yes" "$SSH_CONFIG"; then
    echo "* Password authentication successfully enabled"
  else
    echo "* Failed to enable password authentication"
    exit 1
  fi
elif grep -q "^\s*$KEY yes" "$SSH_CONFIG"; then
  echo "* Password authentication is already enabled"
else
  echo "* Adding password authentication setting..."
  echo "$KEY yes" >> "$SSH_CONFIG"
fi

echo -e "\nCurrent SSH password authentication setting:"
grep "^\s*$KEY" "$SSH_CONFIG"

echo -e "\nRestarting SSH service..."
if systemctl restart sshd; then
  echo "* SSH service restarted successfully"
else
  echo "* Failed to restart SSH service"
  exit 1
fi

echo -e "\n✅ SSH password authentication is now enabled"
echo "====== Configuration complete ======"
