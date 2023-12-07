#!/bin/bash

PACKAGE_LIST="package_lists/fedora_packages_list.txt"

install_packages() {
    echo "Installing dnf packages..."
    sudo dnf install -y $(<"$PACKAGE_LIST")
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
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    source ~/.bashrc
}

install_mern() {
    install_nvm
    echo "To install node run: nvm install 20.8.0"

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
	sudo dnf install dnf-plugins-core

	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

	sudo dnf install brave-browser
}

install_jetbrains_toolbox() {
	wget -c https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.1.1.18388.tar.gz
	sudo tar -xzf jetbrains-toolbox-2.1.1.18388.tar.gz -C ~/Downloads
}

install_virtualbox() {
	echo "Installing Virtual Box"
	wget -c https://download.virtualbox.org/virtualbox/7.0.12/virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
	sudo apt install ./virtualbox-7.0_7.0.12-159484~Debian~bookworm_amd64.deb
}

enable_flathub() {
    echo "Installing flathub"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

grant_execution_permission() {
    chmod +x mount_directories.sh
}

install_vscode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    dnf check-update
    sudo dnf install code --assumeyes
}

add_ssh_key() {
	ssh-add ~/.ssh/id_ed25519
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
    install_mern
    install_virtualbox
    install_jetbrains_toolbox
    install_vscode
    echo "Post-installation script completed."
}

main
