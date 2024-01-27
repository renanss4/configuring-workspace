#!/bin/bash

# Oracle JDK Download URL
JDK_URL="https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb"

# Download JDK
wget $JDK_URL

# Verify the checksum
EXPECTED_CHECKSUM="...expected SHA256 checksum..."
ACTUAL_CHECKSUM=$(sha256sum jdk-17_linux-x64_bin.deb | awk '{print $1}')

if [ "$ACTUAL_CHECKSUM" != "$EXPECTED_CHECKSUM" ]; then
    echo "Checksum verification failed. Exiting."
    exit 1
fi

# Install JDK
sudo dpkg -i jdk-17_linux-x64_bin.deb
sudo apt-get install -f

# Set JAVA_HOME
echo "export JAVA_HOME=/usr/lib/jvm/java-17-oracle" >> ~/.bashrc
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc
source ~/.bashrc

# Verify installation
java -version
