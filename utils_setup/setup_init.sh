#!/bin/bash

# Update package lists
sudo apt-get update -qq

# Check for git
if ! command -v git &>/dev/null; then
    echo "Installing git..."
    sudo apt-get install -y git -qq
else
    echo "git is already installed."
fi

# Check for node (version 18+)
if ! command -v node &>/dev/null || [ "$(node -v | cut -d'.' -f1 | tr -d 'v')" -lt 18 ]; then
    echo "Installing Node 18+..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs -qq
else
    echo "Node 18+ is already installed."
fi

# Check for python3 (version 3+)
if ! command -v python3 &>/dev/null; then
    echo "Installing Python 3+..."
    sudo apt-get install -y python3 -qq
else
    echo "Python 3+ is already installed."
fi

# Check for kubectl command
if ! command -v kubectl &>/dev/null; then
    echo "Installing Kubectl..."
    sudo snap install kubectl --classic &>/dev/null
else
    echo "kubectl is already installed."
fi