#!/bin/bash

# Prompt for GitHub information
read -p "Enter your GitHub username: " github_username
read -p "Enter your GitHub email: " github_email

# Default path for the private key
private_key_path="~/.ssh/id_rsa"

# Check if the .ssh directory exists, if not, create it
ssh_directory="$HOME/.ssh"
if [ ! -d "$ssh_directory" ]; then
    mkdir "$ssh_directory"
fi

# Generate a new SSH key if it doesn't exist
if [ ! -f "$(eval echo $private_key_path)" ]; then
    ssh-keygen -t rsa -b 4096 -C "$github_email" -f "$(eval echo $private_key_path)"
fi

# Add the SSH key to the SSH agent
eval "$(ssh-agent -s)"
ssh-add "$(eval echo $private_key_path)"

# Print the public key to be added to your GitHub profile
public_key="$(eval echo $private_key_path).pub"
echo -e "\nCopy the following public key and add it to your GitHub profile:\n"
cat "$public_key"

# Configure Git user and email
git config --global user.name "$github_username"
git config --global user.email "$github_email"

echo -e "\nConfiguration completed!"
