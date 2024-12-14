#!/bin/bash
set -euo pipefail

echo "blacklist cedrus" | sudo tee /etc/modprobe.d/blacklist-cedrus.conf

cp -rfv /tmp/overlay/etc/99-usb-automount.rules /etc/udev/rules.d/99-usb-automount.rules
