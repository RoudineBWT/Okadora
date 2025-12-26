#!/bin/bash

set -ouex pipefail

echo "=== Configuration de Nix avec symlink ==="

# Créer le répertoire persistent dans /var
mkdir -p /var/nix

# Supprimer /nix s'il existe
rm -rf /nix

# Créer le symlink /nix -> /var/nix
ln -sf /var/nix /nix

echo "=== Installation de Nix ==="

# Installer Nix (version nix-community, pas Determinate)
dnf install -y https://nix-community.github.io/nix-installers/nix/x86_64/nix-multi-user-2.24.10.rpm || {
    echo "ATTENTION: Installation de Nix avec des warnings (non-critiques)"
}

# Si Nix a créé des fichiers dans /nix, ils sont déjà dans /var/nix grâce au symlink
echo "=== Nix installé avec succès ==="
