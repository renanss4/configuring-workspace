#!/bin/bash

# Eclipse Download URL (replace with the desired version)
ECLIPSE_URL="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2021-09/R/eclipse-java-2021-09-R-linux-gtk-x86_64.tar.gz"

# Download Eclipse
wget -O eclipse.tar.gz $ECLIPSE_URL

# Extract Eclipse to /opt
sudo tar -xzf eclipse.tar.gz -C /opt

# Create a symbolic link
sudo ln -s /opt/eclipse/eclipse /usr/local/bin/eclipse

# Create a desktop entry
echo "[Desktop Entry]
Name=Eclipse
Type=Application
Exec=/opt/eclipse/eclipse
Terminal=false
Icon=/opt/eclipse/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse" | sudo tee /usr/share/applications/eclipse.desktop

# Clean up
rm eclipse.tar.gz

# Notify the user
echo "Eclipse installed successfully."
