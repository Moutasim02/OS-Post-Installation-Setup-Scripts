#!/bin/bash

PACKAGE_LIST="package_lists/fedora_packages_list.txt"
FLATPAK_PACKAGE_LIST="package_lists/flatpak_list.txt"
EXTENSIONS_LIST_FILE="extension_lists/extensions_list.txt"
INSTALLED_EXTENSIONS_FILE="installed_extensions.txt"

install_packages() {
    echo "Updating package list..."
    sudo dnf update -y

    echo "Installing dnf packages..."
    install_from_list "$PACKAGE_LIST"
}

install_flatpak_packages() {
    echo "Installing flatpak packages..."
    install_flatpak_from_list "$FLATPAK_PACKAGE_LIST"
}

install_flatpak_from_list() {
    local flatpak_file="$1"
    if [ -f "$flatpak_file" ]; then
        flatpak install flathub --noninteractive $(<"$flatpak_file")
    else
        echo "Flatpak Package list file not found: $flatpak_file"
    fi
}

install_from_list() {
    local list_file="$1"

    if [ -f "$list_file" ]; then
        sudo dnf install -y $(<"$list_file")
    else
        echo "DNF Package list file not found: $list_file"
    fi
}

install_gnome_extensions() {
    local extensions_file="$1"
    if [ -f "$extensions_file" ]; then
        echo "Installing GNOME Shell extensions from $extensions_file..."
        gnome-extensions install $(<"$extensions_file")
    else
        echo "Extensions list file not found: $extensions_file"
    fi
}

export_installed_extensions() {
    echo "Exporting installed extensions to $INSTALLED_EXTENSIONS_FILE..."
    gnome-extensions list > "$INSTALLED_EXTENSIONS_FILE"
}

enable_installed_extensions() {
    echo "Enabling installed GNOME Shell extensions..."
    gnome-extensions enable $(awk '{print $1}' "$INSTALLED_EXTENSIONS_FILE")
}

configure_gnome() {
    install_gnome_extensions "$EXTENSIONS_LIST_FILE"
    export_installed_extensions
    enable_installed_extensions
}

install_bash_theme() {
    echo "Cloning Synth-Shell project..."
    git clone --recursive https://github.com/andresgongora/synth-shell.git

    echo "Navigating to the Synth-Shell project folder..."
    cd synth-shell

    echo "Giving executable permissions to the setup script..."
    sudo chmod +x setup.sh

    echo "Running the Synth-Shell installer..."
    ./setup.sh

    echo "Going back to the previous directory"
    cd ..
}

config_workspaces() {
    echo "Enable workspaces for all monitors"
    gsettings set org.gnome.mutter workspaces-only-on-primary false
    echo "Enable Isolation of apps"
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
}

config_power_management() {
    echo "Stop Automatic Suspend"
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
    gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0

    echo "Stop Screen Dimming"
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false

    echo "Prevent Screen from Blanking"
    gsettings set org.gnome.desktop.session idle-delay 0
}

add_arabic_layout() {
    echo "Adding Arabic layout"
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ara')]"
    echo "Arabic keyboard layout added."
}

configure_system() {
    configure_gnome
    config_workspaces
    config_power_management
    add_arabic_layout
}

install_nvm() {
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    source ~/.bashrc
}

install_mern() {
    install_nvm
    echo "Installing node"
    nvm install 20.8.0

    echo "Installing MongoDB..."
    sudo dnf install -y mongodb
}

install_docker() {
    echo "Installing Docker..."
    sudo dnf install -y docker docker-compose

    echo "Starting Docker service..."
    sudo systemctl start docker

    echo "Enabling Docker service on boot..."
    sudo systemctl enable docker
}

install_brave() {
    sudo dnf install -y brave-browser
}

create_a_pwa() {
    local name="$1"
    local url="$2"
    local desktop_file="$HOME/Desktop/$name.desktop"

    cat <<EOL >"$desktop_file"
[Desktop Entry]
Name=$name
Exec=xdg-open $url
Type=Application
Icon=web-browser
EOL

    chmod +x "$desktop_file"
    echo "Desktop file created for $name at $desktop_file"
}

create_pwas() {
    echo "Creating PWAs for specified websites"
    create_a_pwa "X" "https://x.com"
    create_a_pwa "Teams" "https://teams.microsoft.com"
    create_a_pwa "Tldraw" "https://www.tldraw.com"
    create_a_pwa "Whatsapp Web" "https://web.whatsapp.com"
    create_a_pwa "Notion" "https://www.notion.so"
    create_a_pwa "Outlook" "https://outlook.office.com/mail"
    create_a_pwa "ChatGPT" "https://chat.openai.com"
    create_a_pwa "Bard" "https://bard.google.com/chat"
    create_a_pwa "Figma" "https://www.figma.com"
}

enable_flathub() {
    echo "Installing flathub"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

grant_execution_permission() {
	sudo chmod +x mount_directories.sh
}

main() {
    grant_execution_permission
    bash mount_directories.sh
    install_packages
    enable_flathub
    install_flatpak_packages
    configure_system
    install_brave
    install_mern
    install_docker
    create_pwas
    echo "Post-installation script completed."
}

main
