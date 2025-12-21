#!/usr/bin/bash
set -euo pipefail

echo "Forcing niri as default session for all users..."

# Force niri session for all existing users
for user_file in /var/lib/AccountsService/users/*; do
    if [ -f "$user_file" ]; then
        # Remove existing session lines
        sed -i '/^XSession=/d' "$user_file" 2>/dev/null || true
        sed -i '/^Session=/d' "$user_file" 2>/dev/null || true
        
        # Add niri session
        echo "XSession=niri" >> "$user_file"
        echo "Session=niri" >> "$user_file"
        
        echo "  → Forced niri session for user: $(basename "$user_file")"
    fi
done

echo "Done forcing niri session."