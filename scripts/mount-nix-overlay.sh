#!/bin/bash

set -euo pipefail


if mountpoint -q /nix; then
    echo "/nix is already mounted"
    exit 0
fi


mkdir -p /usr/share/nix-store
mkdir -p /var/lib/nix-store
mkdir -p /var/cache/nix-store
mkdir -p /nix


if ! lsmod | grep -q overlay; then
    modprobe overlay
fi

# Monter l'overlay
mount -t overlay overlay \
    -o lowerdir=/usr/share/nix-store,upperdir=/var/lib/nix-store,workdir=/var/cache/nix-store \
    /nix

echo "OverlayFS for /nix mounted successfully"
