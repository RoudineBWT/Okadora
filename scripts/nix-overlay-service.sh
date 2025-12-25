#!/bin/bash
set -ouex pipefail

# Préparer les répertoires nécessaires
mkdir -p /usr/share/nix-store      # lowerdir (read-only, contient les données du build)
mkdir -p /var/lib/nix-store        # upperdir (read-write, changements)
mkdir -p /var/cache/nix-store      # workdir (requis par overlay)
mkdir -p /nix                       # point de montage

# Charger le module overlay au démarrage
echo overlay > /etc/modules-load.d/overlay.conf

# Créer le service systemd
cat << 'EOF' > /etc/systemd/system/nix-overlay.service
[Unit]
Description=Mount OverlayFS for /nix with Nix store data
Documentation=man:mount(8)
DefaultDependencies=no
Conflicts=umount.target
Before=local-fs.target umount.target nix-daemon.service
After=systemd-tmpfiles-setup.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStartPre=/usr/bin/mkdir -p /var/lib/nix-store /var/cache/nix-store /nix
ExecStart=/usr/bin/mount -t overlay overlay -o lowerdir=/usr/share/nix-store,upperdir=/var/lib/nix-store,workdir=/var/cache/nix-store /nix
ExecStartPost=/usr/bin/sh -c 'if [ ! -d /nix/store ]; then echo "ERROR: /nix/store not found after overlay mount"; exit 1; fi'
ExecStop=/usr/bin/umount /nix

[Install]
WantedBy=local-fs.target
RequiredBy=nix-daemon.service
EOF

# Activer le service
systemctl enable nix-overlay.service

echo "✓ Nix overlay service configured and enabled"
