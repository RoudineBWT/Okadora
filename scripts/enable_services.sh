#!/bin/bash

set -ouex pipefail

systemctl enable podman.socket
systemctl enable nix-daemon.service
systemctl enable nix-daemon.socket
