#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

PACKAGE_LIST="package_lists/arch_packages_list.txt"
NVM_VERSION="v0.39.5"
NODE_VERSION="lts"

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

install_packages() {
	echo "Installing pacman packages..."
	if [[ -f "$PACKAGE_LIST" ]]; then
		sudo pacman -Syu --noconfirm $(<"$PACKAGE_LIST")
	else
		echo "Package list file not found: $PACKAGE_LIST"
		exit 1
	fi
}

install_bash_theme() {
	if ! command_exists git; then
		echo "Git is not installed. Installing Git..."
		sudo pacman -S --noconfirm git
	fi

	echo "Cloning Synth-Shell project..."
	git clone --recursive https://github.com/andresgongora/synth-shell.git || {
		echo "Failed to clone repo"
		exit 1
	}

	pushd synth-shell
	chmod +x setup.sh
	./setup.sh
	popd
}

install_nvm_and_node() {
	echo "Installing NVM..."
	curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

	echo "Installing Node.js..."
	nvm install "$NODE_VERSION"
	nvm use "$NODE_VERSION"
	nvm alias default "$NODE_VERSION"
}

install_docker() {
	echo "Installing Docker..."
	sudo pacman -S --noconfirm docker docker-compose
	sudo systemctl enable --now docker
}

install_jetbrains_toolbox() {
	echo "Downloading JetBrains Toolbox..."
	wget -c https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.1.18388.tar.gz -O ~/Downloads/jetbrains-toolbox.tar.gz
	tar -xzf ~/Downloads/jetbrains-toolbox.tar.gz -C ~/Downloads
}

install_kvm_qemu() {
	echo "Installing KVM/QEMU and virt-manager..."
	sudo pacman -S --noconfirm qemu virt-manager libvirt edk2-ovmf bridge-utils dnsmasq openbsd-netcat
	sudo systemctl enable --now libvirtd
}

install_vscode() {
	echo "Installing Visual Studio Code..."
	sudo pacman -S --noconfirm code
}

main() {
	echo "Starting the installation script..."
	install_packages
	install_bash_theme
	install_nvm_and_node
	install_docker
	install_kvm_qemu
	install_jetbrains_toolbox
	install_vscode
	echo "Post-installation script completed successfully."
}

main
