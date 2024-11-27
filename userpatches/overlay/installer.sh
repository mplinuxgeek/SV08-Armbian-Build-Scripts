#!/bin/bash

# Set USERNAME and HOME variables
USERNAME="${USERNAME:-sovol}"
HOME="/home/$USERNAME"

# Ensure working in the user's home directory
cd "$HOME" || { echo "Error: Could not change directory to $HOME"; exit 1; }

# Clone KIAUH repository if not already cloned
if [[ ! -d "$HOME/kiauh" ]]; then
    git clone https://github.com/dw-0/kiauh.git "$HOME/kiauh"
fi

# Set KIAUH_SRCDIR to point to the cloned KIAUH directory
export KIAUH_SRCDIR="$HOME/kiauh"

# Navigate to KIAUH directory
cd "$KIAUH_SRCDIR" || { echo "Error: Could not change directory to $KIAUH_SRCDIR"; exit 1; }

# Source all necessary scripts in KIAUH
for script in scripts/*.sh scripts/ui/*.sh; do
    . "$script"
done

# Helper function to set up a web interface (Fluidd or Mainsail) on a specified port
function setup_web_interface() {
    local interface_name=$1      # "fluidd" or "mainsail"
    local install_function=$2    # installation function, e.g., install_fluidd or install_mainsail
    local port=$3                # target port, e.g., 80 or 81

    echo "###### Installing $interface_name on port $port..."
    yes | "$install_function"

    # Define the NGINX configuration path
    local nginx_config="/etc/nginx/sites-available/$interface_name"
    
    # Update the first occurrence of "listen 80;" in NGINX configuration to the specified port
    if [[ -f "$nginx_config" ]]; then
        sudo sed -i "0,/listen 80;/s//listen $port;/" "$nginx_config"
        sudo ln -sf "$nginx_config" /etc/nginx/sites-enabled/
    else
        echo "Error: NGINX configuration for $interface_name not found at $nginx_config"
        return 1
    fi

    # Reload NGINX to apply changes
    if command -v systemctl &> /dev/null; then
        sudo systemctl reload nginx || echo "Warning: Could not reload NGINX. Check service status."
    fi
    echo "$interface_name has been set up on port $port."
}

# Set global variables required by KIAUH
set_globals

# Set up Moonraker
echo "###### Setting up Moonraker..."
moonraker_setup 1

# Set up Klipper
echo "###### Setting up Klipper..."
start_klipper_setup << EOF
1
1
EOF

# Install Fluidd on port 80 and Mainsail on port 81
setup_web_interface "mainsail" "install_mainsail" 81
setup_web_interface "fluidd" "install_fluidd" 80

# Install Crowsnest Webcam Service
echo "###### Installing Crowsnest..."
yes n | install_crowsnest

# Install KlipperScreen
echo "###### Installing KlipperScreen..."
yes | install_klipperscreen

# Install Gcode_shell_command extension
echo "###### Installing Gcode_shell_command extension..."
yes | setup_gcode_shell_command

# Install moonraker-timelapse
echo "###### Installing moonraker-timelapse..."
if [[ ! -d "$HOME/moonraker-timelapse" ]]; then
    git clone https://github.com/mainsail-crew/moonraker-timelapse.git "$HOME/moonraker-timelapse"
fi

cd "$HOME/moonraker-timelapse" || { echo "Error: Could not change directory to $HOME/moonraker-timelapse"; exit 1; }
yes | make install

# Install necessary packages for numpy and matplotlib
echo "###### Installing additional packages for numpy and matplotlib..."
sudo apt-get update && sudo apt-get install -y python3-numpy python3-matplotlib libatlas-base-dev libopenblas-dev
"$HOME/klippy-env/bin/pip" install -v numpy

printf "yes\nhttps://app.obico.io\n\n" | moonraker_obico_setup_dialog || true

echo "Installation completed successfully."
