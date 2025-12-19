#!/bin/bash

# custom name
HOME_URL="https://github.com/RoudineBWT/okadora"
echo "okadora" | tee "/etc/hostname"

sed -i -f - /usr/lib/os-release <<EOF
s|^NAME=.*|NAME=\"okadora\"|
s|^PRETTY_NAME=.*|PRETTY_NAME=\"okadora\"|
s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"Posture\"|
s|^VARIANT_ID=.*|VARIANT_ID=""|
s|^HOME_URL=.*|HOME_URL=\"${HOME_URL}\"|
s|^CPE_NAME=\".*\"|CPE_NAME=\"cpe:/o:matthias-adr:okadora\"|
s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"${HOME_URL}\"|
s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME="okadora"|

/^REDHAT_BUGZILLA_PRODUCT=/d
/^REDHAT_BUGZILLA_PRODUCT_VERSION=/d
/^REDHAT_SUPPORT_PRODUCT=/d
/^REDHAT_SUPPORT_PRODUCT_VERSION=/d
EOF