#!/bin/bash
set -euo pipefail

# Define the path for the systemd service file
service_file="/etc/systemd/system/update-serial-devices.service"

# Define the content of the service file
service_content="[Unit]
Description=Update Serial Devices in printer.cfg
After=network.target

[Service]
ExecStart=/usr/local/bin/detect_serial_devices
Type=oneshot

[Install]
WantedBy=multi-user.target
"

# Create the systemd service file with the defined content
echo "$service_content" | sudo tee "$service_file" > /dev/null

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable update-serial-devices.service

echo "Service 'update-serial-devices' has been created, enabled, and will run on startup."