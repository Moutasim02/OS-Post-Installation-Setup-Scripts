#!/bin/bash

PACKAGE_LIST="package_lists/debian_packages_list.txt"

install_packages() {
	echo "Updating package list..."
	sudo apt update

	echo "Installing apt packages..."
	install_from_list "$PACKAGE_LIST"
}

install_from_list() {
	local list_file="$1"
	if [ -f "$list_file" ]; then
		sudo apt install -y $(<"$list_file")
	else
		echo "APT Package list file not found: $list_file"
	fi
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

install_nvm() {
	echo "Installing NVM..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
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
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
		sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt-get update

	echo "Installing required packages"
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

}

install_brave() {
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt update -y
	sudo apt install -y brave-browser
}

install_jetbrains_toolbox() {
	wget -c https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.1.18388.tar.gz
	sudo tar -xzf jetbrains-toolbox-2.1.1.18388.tar.gz -C ~/Downloads
}

enable_flathub() {
	echo "Installing flathub"
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

grant_execution_permission() {
	sudo chmod +x mount_directories.sh
}

install_virtualbox() {
	echo "Installing Virtual Box"
	wget -c https://download.virtualbox.org/virtualbox/7.0.12/virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
	sudo apt install ./virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
}

add_ssh_key() {
	ssh-add ~/.ssh/id_ed25519
}

install_vscode() {
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg

	echo "Retrieve VS Code Package"
	sudo apt install -y apt-transport-https
	sudo apt update -y
	sudo apt install -y code
}

mount_process() {
	bash mount_directories.sh
	sudo cp mount_directories.sh /usr/local/bin/
	sudo chmod +x /usr/local/bin/mount_directories.sh
	sudo cp bind-mounts.service /etc/systemd/system/bind-mounts.service
	sudo systemctl daemon-reload
	sudo systemctl enable bind-mounts.service
}

main() {
	grant_execution_permission
	mount_process
	add_ssh_key
	install_packages
	enable_flathub
	# Specific installations
	install_bash_theme
	install_brave
	install_docker
	install_nvm
	install_virtualbox
	install_jetbrains_toolbox
	install_vscode
	echo "Post-installation script completed."
}

main
