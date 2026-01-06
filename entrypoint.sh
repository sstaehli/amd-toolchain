#!/bin/bash

# Add dummy interface for license
#ip link add ethlic type dummy \
#ifconfig ethlic hw ether 00:11:6B:68:48:45

# Start Xvfb
exec Xvfb :1 -screen 0 1024x768x16 &

# source vivado settings
echo "Sourcing Vitis settings from: $VITIS_SETTINGS_PATH"
source $VITIS_SETTINGS_PATH
echo "Sourcing Vivado settings from: $VIVADO_SETTINGS_PATH"
source $VIVADO_SETTINGS_PATH

# Start command
exec "$@"