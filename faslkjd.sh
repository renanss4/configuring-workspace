#!/bin/bash

# Hi, welcome to my script. I hope that you like it and have fun!

# Oi, bem-vindo ao meu script. Eu espero que você goste e se divirta!

# Function to check the system language
check_system_language() {
    language=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d: -f1)
    if [[ "$language" != "en_US" ]]; then
        echo "Your system language is set to $language."
        read -p "Are you sure you want to continue with the installation? (y/n): " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            return 0
        else
            echo "Aborted."
            exit 1
        fi
    fi
}

# Check system language before proceeding
check_system_language

# Function to check if a package is installed
check_package() {
    if dpkg -l "$1" &> /dev/null; then
        echo "$1 is already installed."
        return 0
    else
        return 1
    fi
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

# Function to install Chrome
install_chrome() {
    if ! check_package "google-chrome-stable"; then
        echo "Downloading and installing Google Chrome..."
        wget -O /tmp/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        sudo dpkg -i /tmp/chrome.deb
        sudo apt install -f
        echo "Google Chrome installed successfully."
    else
        echo "Google Chrome is already installed."
    fi
}

# Function to install Spotify
install_spotify() {
    if ! check_package "spotify-client"; then
        echo "Downloading and installing Spotify..."
        sudo apt install snapd -y
        sudo snap install spotify
        echo "Spotify installed successfully."
    else
        echo "Spotify is already installed."
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

# Function to create folders on the desktop or Área de Trabalho
create_folders() {
    desktop_path="$HOME/Desktop"
    projects_path="$desktop_path/Projects"
    workspace_path="$desktop_path/Workspace"

    # Check system language
    system_language=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d: -f1)

    if [[ "$system_language" == "pt_BR"* ]]; then
        desktop_path="$HOME/Área de Trabalho"
        projects_path="$desktop_path/Projects"
        workspace_path="$desktop_path/Workspace"
    fi

    # Check if folders exist
    if [ -d "$projects_path" ] && [ -d "$workspace_path" ]; then
        echo "Folders already exist. No need to create."
    else
        mkdir -p "$projects_path"
        mkdir -p "$workspace_path"
        echo "Folders created on the desktop or Área de Trabalho."
    fi
}

# Function to print Hello World in binary ASCII art
print_hello_world() {
    cat << "EOF"
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
- 01001000 01100101 01101100 01101100 01101111              -
- 01010111 01101111 01110010 01101100 01100100 00100001     -
-  __  __          ___    ___                               -
- /\ \/\ \        /\_ \  /\_ \                              -
- \ \ \_\ \     __\//\ \ \//\ \     ___                     -
-  \ \  _  \  /'__`\\ \ \  \ \ \   / __`\                   -
-   \ \ \ \ \/\  __/ \_\ \_ \_\ \_/\ \L\ \                  -
-    \ \_\ \_\ \____\/\____\/\____\ \____/                  -
-     \/_/\/_/\/____/\/____/\/____/\/___/                   -
-                                                           -
-                                                           -
-  __      __                 ___       __  __              -
- /\ \  __/\ \               /\_ \     /\ \/\ \             -
- \ \ \/\ \ \ \    ___   _ __\//\ \    \_\ \ \ \            -
-  \ \ \ \ \ \ \  / __`\/\`'__\\ \ \   /'_` \ \ \           -
-   \ \ \_/ \_\ \/\ \L\ \ \ \/  \_\ \_/\ \L\ \ \_\          -
-    \ `\___x___/\ \____/\ \_\  /\____\ \___,_\/\_\         -
-     '\/__//__/  \/___/  \/_/  \/____/\/__,_ /\/_/   r3n4n -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
EOF
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

# Function to choose which programs to install
choose_installations() {
    print_hello_world
    ask_sudo_password
    read -p "Enter your name: " username
    echo "Hello $username! How would you like to configure your environment?"
    echo "1- Install Everything"
    echo "2- Essential Packages"
    echo "3- Python"
    echo "4- Jupyter"
    echo "5- Visual Studio Code"
    echo "6- Spotify"
    echo "7- Google Chrome"
    echo "8- Do not install anything"

    read -p "Enter the number corresponding to your desired option: " choice

    case $choice in
        1) install_everything ;;
        2) install_essential_packages ;;
        3) install_python ;;
        4) install_jupyter ;;
        5) install_vscode ;;
        6) install_spotify ;;
        7) install_chrome ;;
        8) echo "Nothing will be installed. Exiting." ;;
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

