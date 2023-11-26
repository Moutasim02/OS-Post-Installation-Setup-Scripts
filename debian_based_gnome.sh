#!/bin/bash

PACKAGE_LIST="package_lists/debian_packages_list.txt"
FLATPAK_PACKAGE_LIST="package_lists/flatpak_list.txt"
EXTENSIONS_LIST_FILE="extension_lists/extensions_list.txt"
INSTALLED_EXTENSIONS_FILE="installed_extensions.txt"

install_packages() {
	echo "Updating package list..."
	sudo apt update

	echo "Installing apt packages..."
	install_from_list "$PACKAGE_LIST" "FLATPAK_PACKAGE_LIST"
}

install_flatpak_packages() {
        echo "Installing flatpak packages..."
        install_flatpak_from_list "FLATPAK_PACKAGE_LIST"
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
	sudo apt install -y $(<"$list_file")
	else
	echo "APT Package list file not found: $list_file"
	fi
}

install_gnome_extensions() {
    local extensions_file="$1"
    if [ -f "$extensions_file" ]; then
        echo "Installing GNOME Shell extensions from $extensions_file..."
        while IFS= read -r extension_id; do
            gnome-extensions install "$extension_id"
        done < "$extensions_file"
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

install_bash_theme() {
	echo "Cloning Synth-Shell project..."
	git clone --recursive https://github.com/andresgongora/synth-shell.git

	echo "Navigating to the Synth-Shell project folder..."
	cd synth-shell

	echo "Giving executable permissions to the setup script..."
	sudo chmod +x setup.sh

	echo "Running the Synth-Shell installer..."
	./setup.sh

	echo "Going back to previous directory"
	cd ..
}

config_workspaces() {
	echo "Enable workspaces for all monitors"
	gsettings set org.gnome.mutter workspaces-only-on-primary false
	echo "Enable Isolation of apps"
	gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
}

configure_gnome() {
	install_gnome_extensions "$EXTENSIONS_LIST_FILE"
	export_installed_extensions
	enable_installed_extensions
	install_bash_theme
	config_workspaces
}

install_nvm() {
	echo "Installing NVM..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	source ~/.bashrc
}

install_mern() {
	install_nvm
	echo "Installing node"
	nvm install 20.8.0

	echo "Installing MongoDB..."
    	curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
   	sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   	--dearmor
	echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bullseye/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
	sudo apt-get update
	sudo apt-get install -y mongodb-org mongodb-org-database mongodb-org-tools mongodb-org-tools
	echo "Start mongod"
	sudo systemctl start mongod
	echo "MongoDB Status:"
	sudo systemctl status mongod
}

install_docker() {
	echo "Adding Docker's official GPG key"
	sudo apt-get update -y
	sudo apt-get install -y ca-certificates curl gnupg
	sudo install -m 0755 -d /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	sudo chmod a+r /etc/apt/keyrings/docker.gpg

	echo "Adding the repository to Apt sources"
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update

	echo  "Installing required packages"
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

}

install_brave() {
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update -y
	sudo apt install -y brave-browser
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
	echo "Adding arabic layout"
	gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ara')]"
	echo "Arabic keyboard layout added."
}

configure_system() {
    	echo "Configuring system..."
	configure_gnome
	config_power_management
	add_arabic_layout
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

install_jetbrains_toolbox() {
        wget -c https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.1.18388.tar.gz
        sudo tar -xzf jetbrains-toolbox-2.1.1.18388.tar.gz -C ~/Downloads
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

install_virtualbox() {
	wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
	sudo apt-get update -y
	sudo apt-get install -y virtualbox-6.1
}

main() {
	grant_execution_permission
	bash mount_directories.sh
	install_packages
	enable_flathub
        install_flatpak_packages
	configure_system
	install_virtualbox
        install_brave
        install_mern
        install_docker
        install_jetbrains_toolbox
	create_pwas
	echo "Post-installation script completed."
}

main

