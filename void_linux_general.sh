#!/bin/bash

PACKAGE_LIST="package_lists/void_packages_list.txt"

install_packages() {
	echo "Updating package list..."
	sudo xbps-install -Su

	echo "Installing xbps packages..."
	install_from_list "$PACKAGE_LIST"
}

install_from_list() {
	local list_file="$1"
	if [ -f "$list_file" ]; then
		sudo xbps-install -y $(<"$list_file")
	else
		echo "XBPS Package list file not found: $list_file"
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

	echo "Going back to the previous directory"
	cd ..
}

install_nvm() {
	echo "Installing NVM..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
	export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

install_docker() {
	echo "Installing Docker..."
	sudo xbps-install -S docker docker-cli
}

install_jetbrains_toolbox() {
	wget -c https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.1.18388.tar.gz
	sudo tar -xzf jetbrains-toolbox-2.1.1.18388.tar.gz -C /opt
	sudo ln -s /opt/jetbrains-toolbox-*/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox
}

enable_flathub() {
	sudo xbps-install -S flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

grant_execution_permission() {
	sudo chmod +x mount_directories.sh
}

install_kvm() {
	sudo xbps-install -S dbus qemu libvirtd virt-manager bridge-utils iptables2 polkit
	# link services
	sudo ln -s /etc/sv/polkitd /var/service
	sudo ln -s /etc/sv/libvirtd /var/service
	sudo ln -s /etc/sv/virtlockd /var/service
	sudo ln -s /etc/sv/virtlogd /var/service
}

add_ssh_key() {
	ssh-add ~/.ssh/id_ed25519
}

install_vscode() {
	sudo xbps-install -S vscode
}

mount_process() {
	bash mount_directories.sh
	sudo cp mount_directories.sh /usr/local/bin/
	sudo chmod +x /usr/local/bin/mount_directories.sh
	sudo mkdir -p /etc/sv/bind-mounts
	sudo cp run /etc/sv/bind-mounts/
	sudo chmod +x /etc/sv/bind-mounts/run
	sudo ln -s /etc/sv/bind-mounts /var/service
	sudo sv start bind-mounts
	sudo sv status bind-mounts
}

main() {
	grant_execution_permission
	mount_process
	add_ssh_key
	install_packages
	# Specific installations
	install_bash_theme
	install_docker
	install_nvm
	install_kvm
	install_jetbrains_toolbox
	install_vscode
	echo "Post-installation script completed."
}

main
