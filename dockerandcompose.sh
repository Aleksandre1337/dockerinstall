#!/bin/bash

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

log "Initiating docker and docker-compose installation"

log "Removing old versions of Docker"
sudo apt-get remove -y docker docker-engine docker.io containerd runc

log "Updating package index"
sudo apt-get update

log "Installing prerequisites"
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

log "Removing old Docker GPG key"
sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg

log "Adding Docker GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

log "Setting up Docker repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

log "Updating package index again"
sudo apt-get update

log "Installing Docker"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

log "Adding user to Docker group"
sudo usermod -a -G docker $USER

log "Downloading Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose

log "Applying executable permissions to Docker Compose"
sudo chmod +x /usr/local/bin/docker-compose

log "Refreshing group membership"
newgrp docker

log "Installation successful"
