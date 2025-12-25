#!/bin/bash
set -ouex pipefail

# Assurer que /root existe
if [ ! -d /root ] || [ ! -w /root ]; then
    rm -rf /root 2>/dev/null || true
    mkdir -p /root
    chmod 0750 /root
    chown root:root /root
fi

# Installer Nix
dnf install -y https://nix-community.github.io/nix-installers/nix/x86_64/nix-multi-user-2.24.10.rpm

if [ -d /nix/store ]; then
  echo "Moving Nix store to /usr/share/nix-store..."
  mkdir -p /usr/share/nix-store
  rsync -a /nix/ /usr/share/nix-store/ || mv /nix/* /usr/share/nix-store/ || true
  rm -rf /nix
  mkdir -p /nix
  echo "Nix store moved successfully"
fi

if [ -d /usr/share/nix-store/store ]; then
  echo "✓ Nix store data present in /usr/share/nix-store"
  ls -la /usr/share/nix-store/
else
  echo "⚠ Warning: No Nix store data found in /usr/share/nix-store"
fi
