#!/bin/bash

# Postman Download URL
POSTMAN_URL="https://dl.pstmn.io/download/latest/linux"

# Download and extract Postman
wget -O postman.tar.gz $POSTMAN_URL
sudo tar -xzf postman.tar.gz -C /opt

# Create a symbolic link
sudo ln -s /opt/Postman/Postman /usr/local/bin/postman

# Create a desktop entry
echo "[Desktop Entry]
Name=Postman
Exec=postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" | sudo tee /usr/share/applications/postman.desktop

# Cleanup
rm postman.tar.gz

# Notify the user
echo "Postman installed successfully."
