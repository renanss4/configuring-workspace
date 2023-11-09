#!/bin/bash

# Function to check if a package is installed
check_package() {
    if dpkg -l "$1" &> /dev/null; then
        echo "$1 is already installed."
        return 0
    else
        return 1
    fi
}

# Function to ask for sudo password
ask_sudo_password() {
    sudo -v
    while true; do
        sudo true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Function to update the system
update_system() {
    echo "Checking Internet connection..."
    if ping -q -c 1 -W 1 google.com &> /dev/null; then
        echo "Internet connection found. Updating the system..."
        sudo apt update -y && sudo apt upgrade -y
        echo "System updated successfully."
    else
        echo "No Internet connection. Unable to update the system."
    fi
}

# Function to install essential packages
install_essential_packages() {
    packages=("git" "curl" "build-essential" "gcc" "make" "default-libmysqlclient-dev" "libssl-dev")
    
    for package in "${packages[@]}"; do
        if ! check_package "$package"; then
            sudo apt install "$package" -y
        fi
    done

    echo "Essential packages installed successfully."
}

# Function to install Python
install_python() {
    python_version="3.10"
    if ! check_package "python${python_version}-full" || ! check_package "python${python_version}-dev"; then
        sudo apt install "python${python_version}-full" "python${python_version}-dev" -y
        echo "Python ${python_version} installed successfully."
    fi
}

# Function to install Jupyter
install_jupyter() {
    if ! pip3 show jupyter &> /dev/null; then
        pip3 install jupyter
        echo "Jupyter installed successfully."
    else
        echo "Jupyter is already installed."
    fi
}

# Function to install Visual Studio Code
install_vscode() {
    if ! check_package "code"; then
        echo "Downloading and installing Visual Studio Code..."
        wget -O /tmp/vscode.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
        sudo dpkg -i /tmp/vscode.deb
        sudo apt install -f
        echo "Visual Studio Code installed successfully."

        # Add settings to settings.json
        vscode_config="$HOME/.config/Code/User/settings.json"
        mkdir -p "$(dirname "$vscode_config")"
        cat <<EOF >"$vscode_config"
{
    "window.zoomLevel": 2,
    "workbench.startupEditor": "none",
    "explorer.compactFolders": false,
    "workbench.iconTheme": "material-icon-theme",
    "code-runner.executorMap": {
        "python": "clear ; python3 -u",
    },
    "code-runner.runInTerminal": true,
    "code-runner.ignoreSelection": true,
    "editor.fontSize": 14
}
EOF
        echo "Settings added to Visual Studio Code's settings.json."
    else
        echo "Visual Studio Code is already installed."
    fi
}

# Function to install Spotify
install_spotify() {
    if ! check_package "spotify-client"; then
        echo "Downloading and installing Spotify..."
        wget -O /tmp/spotify.deb "https://download.spotify.com/debian/pool/non-free/s/spotify-client/spotify-client_1.1.61.583.gb698b7b4-16_amd64.deb"
        sudo dpkg -i /tmp/spotify.deb
        sudo apt install -f
        echo "Spotify installed successfully."
    else
        echo "Spotify is already installed."
    fi
}

# Function to create folders on the desktop
create_folders() {
    desktop_path="$HOME/Desktop"
    projects_path="$desktop_path/Projects"
    workspace_path="$desktop_path/Workspace"

    mkdir -p "$projects_path"
    mkdir -p "$workspace_path"

    echo "Folders 'Projects' and 'Workspace' created on the desktop."
}

# Function to choose which programs to install
choose_installations() {
    read -p "Enter your name: " username
    echo "Hello $username! How would you like to configure your environment?"
    echo "1- Install Everything"
    echo "2- Essential Packages"
    echo "3- Python"
    echo "4- Jupyter"
    echo "5- Visual Studio Code"
    echo "6- Spotify"
    echo "7- Do not install anything"
    echo "*- Invalid option, nothing will be done"

    read -p "Enter the number corresponding to your desired option: " choice

    case $choice in
        1) install_everything ;;
        2) install_essential_packages ;;
        3) install_python ;;
        4) install_jupyter ;;
        5) install_vscode ;;
        6) install_spotify ;;
        7) echo "Nothing will be installed. Exiting." ;;
        *) echo "Invalid choice. Exiting." ;;
    esac
}

# Function to install everything
install_everything() {
    update_system
    install_essential_packages
    install_python
    install_jupyter
    install_vscode
    install_spotify
    create_folders
}

# Execute the function to choose installations
choose_installations

