#!/bin/bash

# Hi, welcome to my script. I hope that you like it and have fun!

# Oi, bem-vindo ao meu script. Eu espero que você goste e se divirta!

# Constants
PYTHON_VERSION="3.10"
DEADSNAKES_PPA="ppa:deadsnakes/ppa"
VS_CODE_URL="https://go.microsoft.com/fwlink/?LinkID=760868"
CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# Function to check the system language
check_system_language() {
    # Check the system language and prompt the user if it's not English
    language=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d: -f1)
    if [[ "$language" != "en_US" ]]; then
        echo "Your system language is set to $language."
        read -rp "Are you sure you want to continue with the installation? (y/n): " response
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
    # Check if the given package is installed
    dpkg -l "$1" &> /dev/null && { echo "$1 is already installed."; return 0; } || return 1
}

# Function to update the system
update_system() {
    # Check Internet connection and update the system if available
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
    # Install essential packages if not already installed
    packages=("git" "curl" "build-essential" "gcc" "make" "default-libmysqlclient-dev" "libssl-dev")
    
    for package in "${packages[@]}"; do
        check_package "$package" || sudo apt install "$package" -y
    done

    echo "Essential packages installed successfully."
}

# Function to install Python
install_python() {
    # Install Python and its development files
    if [ "$(lsb_release -cs)" == "bionic" ]; then
        echo "You are not on Ubuntu 22.04. Adding deadsnakes PPA for Python $PYTHON_VERSION..."
        sudo add-apt-repository "$DEADSNAKES_PPA"
        sudo apt-get update
    fi

    check_package "python${PYTHON_VERSION}" || {
        sudo apt install "python${PYTHON_VERSION}-full" -y
        echo "Python $PYTHON_VERSION installed successfully."
    }

    check_package "python${PYTHON_VERSION}-dev" || {
        echo "Installing Python $PYTHON_VERSION development files..."
        sudo apt install "python${PYTHON_VERSION}-dev" -y
        echo "Python $PYTHON_VERSION development files installed successfully."
    }

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
    sudo update-alternatives --set python3 /usr/bin/python${PYTHON_VERSION}

    echo "Python $PYTHON_VERSION is now the default version."
    # Additional packages or configurations specific to Python $PYTHON_VERSION
    # Add your custom packages or configurations here
}

# Function to check and install build-essential (includes GCC)
check_and_install_build_essential() {
    check_package "build-essential" || {
        echo "build-essential not found. Installing..."
        sudo apt-get update
        sudo apt-get install -y build-essential gdb
        echo "build-essential installed successfully."
    }

    echo "build-essential is already installed."
}

# Function to install Visual Studio Code and extensions
install_vscode() {
    check_and_install_build_essential
    # Install Visual Studio Code if not already installed
    check_package "code" || {
        echo "Downloading and installing Visual Studio Code..."
        wget -O /tmp/vscode.deb "$VS_CODE_URL"
        sudo dpkg -i /tmp/vscode.deb
        sudo apt install -f
        echo "Visual Studio Code installed successfully."

        # Install VSCode extensions
        echo "Installing VSCode extensions..."
        code --install-extension ms-python.python
        code --install-extension formulahendry.code-runner
        code --install-extension PKief.material-icon-theme
        code --install-extension ms-vscode.cpptools

        vscode_config="$HOME/.config/Code/User/settings.json"
        mkdir -p "$(dirname "$vscode_config")"
        cat <<EOF >"$vscode_config"
{
    // "window.zoomLevel": 2,
    "workbench.startupEditor": "none",
    "explorer.compactFolders": false,
    "workbench.iconTheme": "material-icon-theme",
    "code-runner.executorMap": {
        "python": "clear ; python3 -u",
        "cpp": "clear && g++ -g $fullFileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        "c": "clear && gcc -g $fullFileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        // "lua": "clear && lua $fullFileName",
        // "java": "clear && javac $fullFileName && java $fileNameWithoutExt"
    },
    "code-runner.runInTerminal": true,
    "code-runner.ignoreSelection": true,
    "editor.fontSize": 14
}
EOF
        echo "Settings added to Visual Studio Code's settings.json."
    }

    echo "Visual Studio Code is already installed."
}

# Function to install Chrome
install_chrome() {
    # Install Google Chrome if not already installed
    check_package "google-chrome-stable" || {
        echo "Downloading and installing Google Chrome..."
        wget -O /tmp/chrome.deb "$CHROME_URL"
        sudo dpkg -i /tmp/chrome.deb
        sudo apt install -f
        echo "Google Chrome installed successfully."
    }

    echo "Google Chrome is already installed."
}

# Function to install Spotify
install_spotify() {
    # Install Spotify if not already installed
    check_package "spotify-client" || {
        echo "Downloading and installing Spotify..."
        sudo apt install snapd -y
        sudo snap install spotify
        echo "Spotify installed successfully."
    }

    echo "Spotify is already installed."
}

# Function to create folders on the desktop
create_folders() {
    # Create folders on the desktop based on user input
    desktop_path="$HOME/Desktop"
    projects_path="$desktop_path/Projects"
    workspace_path="$desktop_path/Workspace"

    # Check system language
    system_language=$(locale | grep LANGUAGE | cut -d= -f2 | cut -d: -f1)

    [[ "$system_language" == "pt_BR"* ]] && {
        desktop_path="$HOME/Área de Trabalho"
        projects_path="$desktop_path/Projects"
        workspace_path="$desktop_path/Workspace"
    }

    # Check if folders exist
    [ -d "$projects_path" ] && [ -d "$workspace_path" ] && {
        echo "Folders already exist. No need to create."
    } || {
        echo "Choose which folders to create:"
        echo "1- Create folder Projects"
        echo "2- Create folder Workspace"
        echo "3- Create both folders"

        read -rp "Enter the numbers corresponding to your desired options: " choices

        # Create an array of choices
        choices_array=($(echo "$choices" | sed 's/\(.\)/\1 /g'))

        for choice in "${choices_array[@]}"; do
            case $choice in
                1) mkdir -p "$projects_path" && echo "Folder Projects created." ;;
                2) mkdir -p "$workspace_path" && echo "Folder Workspace created." ;;
                3) mkdir -p "$projects_path" "$workspace_path" && echo "Both folders created." ;;
                *) echo "Invalid choice: $choice. Skipping." ;;
            esac
        done
    }
}

# Function to print Hello World in binary ASCII art
print_hello_world() {
    # Print Hello World in binary ASCII art
    cat << "EOF"
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -    
- 01001000 01100101 01101100 01101111              -
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
-  \ \ \ \ \ \ \  /__`\/\`'__\\ \ \   /'_` \ \ \           -
-   \ \ \_/ \_\ \/\ \L\ \ \ \/  \_\ \_/\ \L\ \ \_\          -
-    \ `\___x___/\ \____/\ \_\  /\____\ \___,_\/\_\         -
-     '\/__//__/  \/___/  \/_/  \/____/\/__,_ /\/_/   r3n4n -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
EOF
}

# Function to ask for sudo password
ask_sudo_password() {
    # Ask for sudo password and keep it valid throughout the script execution
    sudo -v
    while true; do
        sudo true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Function to install essential packages and Python
install_essential_and_python() {
    update_system
    install_essential_packages
    install_python
}

# Function to install applications (Chrome, Spotify, VSCode)
install_applications() {
    update_system
    install_chrome
    install_spotify
    install_vscode
}

# Function to install everything
install_everything() {
    update_system
    install_essential_packages
    install_python
    install_vscode
    install_applications
    create_folders
}

# Function to choose which programs to install
choose_installations() {
    # Main function to choose which programs to install
    print_hello_world
    ask_sudo_password
    read -rp "Enter your name: " username
    echo ""
    echo "Hello $username! How would you like to configure your environment?"
    echo "1- Install Everything"
    echo "2- Essential Packages and Python"
    echo "3- Applications (Chrome, Spotify, VSCode)"
    echo "4- Create folders in Desktop"
    echo "5- Do not install anything"

    read -rp "Enter the numbers corresponding to your desired options (e.g., 23 for Essential Packages, Python and Applications, or 34 for Applications and Create folders): " choices

    # Create an array of choices
    choices_array=($(echo "$choices" | sed 's/\(.\)/\1 /g'))

    for choice in "${choices_array[@]}"; do
        case $choice in
            1) install_everything ;;
            2) install_essential_and_python ;;
            3) install_applications ;;
            4) create_folders ;;
            5) echo "Nothing will be installed. Exiting." ;;
            *) echo "Invalid choice: $choice. Skipping." ;;
        esac
    done
}

# Execute the function to choose installations
choose_installations
