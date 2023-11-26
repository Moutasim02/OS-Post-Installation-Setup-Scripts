# Post-Installation Setup Scripts

This repository contains post-installation setup scripts for various Linux distributions and desktop environments. The setup scripts automate the installation of packages, configurations, and additional tools to enhance your Linux system after a fresh installation.

## Supported Setups

- **Debian-based GNOME Setup**
  - Script: `debian_gnome_setup.sh`
  - Description: This script is designed for Debian-based systems with the GNOME desktop environment. It installs APT packages, Flatpak packages, GNOME Shell extensions, sets up workspaces, configures GNOME settings, installs additional software, and creates Progressive Web Apps (PWAs) for specified websites.

- **Arch-based GNOME Setup**
  - Script: `arch_gnome_setup.sh`
  - Description: This script is tailored for Arch-based systems with the GNOME desktop environment. It handles package installation using Pacman, Flatpak, GNOME Shell extension setup, GNOME configuration, and the creation of PWAs for selected websites.

- **Windows Setup with Winget**
  - Script: `setup_widget.bat`
  - Description: This script is designed for Windows systems and includes configurations for winget. It automates the installation of software and settings to enhance the Windows desktop experience.

- **Fedora-based GNOME Setup**
  - Script: `fedora_gnome_setup.sh`
  - Description: This script is crafted for Fedora-based systems with the GNOME desktop environment. It manages package installation using DNF, installs Flatpak packages, sets up GNOME Shell extensions, configures workspaces, and creates PWAs for specified websites.

## Notes
These scripts are provided as-is, and you should review and understand each script before execution because its heavily tailored to my needs. you can for this repo and make your own.
Make sure to backup important data before running any setup scripts.
Feel free to customize the scripts based on your preferences or specific requirements.
