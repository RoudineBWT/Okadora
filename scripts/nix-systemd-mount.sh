#!/bin/bash

set -ouex pipefail

echo "=== Configuration de Nix avec systemd.mount natif ==="

# S'assurer que les répertoires existent
mkdir -p /var/nix
mkdir -p /nix

# Créer le fichier systemd.mount
# IMPORTANT: Le nom du fichier DOIT correspondre au chemin de montage
# /nix = nix.mount
cat << 'EOF' > /etc/systemd/system/nix.mount
[Unit]
Description=Nix Store Mount Point
Documentation=https://nixos.org/manual/nix/stable/
# systemd gère automatiquement les dépendances sur /var
RequiresMountsFor=/var
# Doit être monté avant que nix-daemon démarre
Before=nix-daemon.service nix-daemon.socket
# Monter après que le système de fichiers local soit prêt
After=local-fs.target

[Mount]
What=/var/nix
Where=/nix
Type=none
Options=bind

[Install]
WantedBy=local-fs.target
EOF

# Activer le mount
systemctl enable nix.mount

echo "=== systemd.mount configuré pour /nix ==="
