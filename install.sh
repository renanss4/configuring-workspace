#!/bin/bash

# Constants
PYTHON_VERSION="3.10"
VS_CODE_URL="https://go.microsoft.com/fwlink/?LinkID=760868"
CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

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
-  \ \ \ \ \ \ \  / __`\/\`'__\\ \ \   /'_` \ \ \           -
-   \ \ \_/ \_\ \/\ \L\ \ \ \/  \_\ \_/\ \L\ \ \_\          -
-    \ `\___x___/\ \____/\ \_\  /\____\ \___,_\/\_\         -
-     '\/__//__/  \/___/  \/_/  \/____/\/__,_ /\/_/   r3n4n -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
EOF
}

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
    check_package "python${PYTHON_VERSION}" || {
        sudo apt install "python${PYTHON_VERSION}-full" -y
        echo "Python $PYTHON_VERSION installed successfully."
    }

    check_package "python${PYTHON_VERSION}-dev" || {
        echo "Installing Python $PYTHON_VERSION development files..."
        sudo apt install "python${PYTHON_VERSION}-dev" -y
        echo "Python $PYTHON_VERSION development files installed successfully."
    }

    check_package "python${PYTHON_VERSION}-pip" || {
        echo "Installing pip for Python $PYTHON_VERSION..."
        sudo apt install "python${PYTHON_VERSION}-pip" -y
        echo "pip for Python $PYTHON_VERSION installed successfully."
    }

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 1
    sudo update-alternatives --set python3 /usr/bin/python${PYTHON_VERSION}

    echo "Python $PYTHON_VERSION is now the default version."
    # Additional packages or configurations specific to Python $PYTHON_VERSION
    # Add your custom packages or configurations here
}

# Function to check and install build-essential (includes GCC)
install_build_essential() {
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
    install_build_essential
    # Install Visual Studio Code if not already installed
    check_package "code" || {
        echo "Downloading and installing Visual Studio Code..."
        wget -O /tmp/vscode.deb "$VS_CODE_URL"
        sudo dpkg -i /tmp/vscode.deb
        sudo apt install -f
        echo "Visual Studio Code installed successfully."

        fullFileName="$(realpath "${BASH_SOURCE[0]}")"
        fileNameWithoutExt="${fullFileName%.*}"

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

# Function to clean up temporary files
cleanup_temp_files() {
    # Remove temporary files
    rm -f /tmp/vscode.deb
    rm -f /tmp/chrome.deb
}

# Function to install everything
install_everything() {
    print_hello_world
    check_system_language
    update_system
    install_essential_packages
    install_python
    install_build_essential
    install_vscode
    install_chrome
    cleanup_temp_files
}

# Start
install_everything