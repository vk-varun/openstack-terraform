#!/bin/bash
set -eux

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y \
  python3 \
  python3-pip \
  python3-venv \
  docker.io \
  python3-docker

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu
