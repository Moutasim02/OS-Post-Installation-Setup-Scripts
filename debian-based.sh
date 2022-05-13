#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   	echo "This script must be run as root" 
   	exit 1
else
	#Update and Upgrade
	echo "Updating and Upgrading"
	apt-get update && sudo apt-get upgrade -y

	sudo apt-get install dialog
	cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "Sublime Text" on    # any option can be set to default to "on"
			2 "LAMP Stack" off
			3 "GIMP (with snapd)" off
			4 "Brave" on
			5 "Git" on
			6 "Figma (with snapd)" on
			7 "Microsoft Teams" off
			8 "Flatpak" on
			9 "Notion" off
			10 "VLC Media Player" off
			11 "Franz (flatpak needed)" on
			12 "Google Chrome" off
			13 "Github Desktop" on
			14 "OBS studio" off
			15 "Intellij Idea - Community" On
			16 "Vscode" on
			17 "Vim" on
			18 "Steam" on
			19 "Gnome Tweaks" off
			)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
			1)
	            #Install Sublime Text 3*
				echo "Installing Sublime Text"
				apt install wget
				wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
				sudo apt-get install apt-transport-https -y
				echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
				sudo apt-get update
				sudo apt-get install sublime-text -y
				;;

			2)
			    #Install LAMP stack
				echo "Installing Apache"
				apt install apache2 -y
		            
	    			echo "Installing Mysql Server"
		 		apt install mysql-server -y

	        		echo "Installing PHP"
				apt install php libapache2-mod-php php-mcrypt php-mysql -y
		            
	        		echo "Installing Phpmyadmin"
				apt install phpmyadmin -y

				echo "Cofiguring apache to run Phpmyadmin"
				echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf
				
				echo "Enabling module rewrite"
				sudo a2enmod rewrite
				echo "Restarting Apache Server"
				service apache2 restart
				;;
    		3)	
				#Install GIMP
				echo "Installing GIMP"
				apt install snapd -y
				snap install gimp
				;;
				
			4)
				#Install Brave
				echo "Installing Brave"
				apt install apt-transport-https curl -y
				sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
				echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
				sudo apt update -y
				sudo apt install brave-browser -y
				;;

			5)
				#Install git
				echo "Installing Git, please configure git later..."
				apt install git -y
				;;

			6)
				#Figma with snapd
				echo "Installing Figma"
				apt install snapd -y
				snap install figma-linux
				;;

			7)
				#Microsoft Teams 
				echo "Installing Microsoft Teams"
				curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
				sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
				sudo apt update
				sudo apt install teams
				;;

			8)
				#Flatpak
				echo "Installing Flatpak"
				apt install flatpak -y
				flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
				;;

			9)
				#Notion
				echo "Installing Notion"
				echo "deb [trusted=yes] https://apt.fury.io/notion-repackaged/ /" | sudo tee /etc/apt/sources.list.d/notion-repackaged.list
				sudo apt update
				sudo apt install notion-app-enhanced
				;;

			10)
				#VLC Media Player
				echo "Installing VLC Media Player"
				apt install vlc -y
				;;

			11)
				#Franz (All in one social media)
				echo "Installing Franz (All in one social media)"
				sudo flatpak install flathub com.meetfranz.Franz
				;;
			12)
				#Chrome
				echo "Installing Google Chrome"
				wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
				sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
				apt-get update 
				apt-get install google-chrome-stable -y
				;;

			13)
				#Github Desktop
				echo "Installing Github Desktop"
				sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.6.3-linux1/GitHubDesktop-linux-2.6.3-linux1.deb
				sudo apt-get install gdebi-core
				sudo gdebi ~/GitHubDesktop-linux-2.6.3-linux1.deb
				;;

			14)
				# OBS Studio
				echo "Installing Obs Studio" 
				apt install ffmpeg -y
				 apt install v4l2loopback-dkms -y
				 add-apt-repository ppa:obsproject/obs-studio -y
				 apt update -y
				 apt install obs-studio -y
				;;
		
			15)
				# IntelliJ Idea
				echo "Installing IntelliJ Idea"
				wget https://download.jetbrains.com/idea/ideaIC-2021.2.3.tar.gz
				tar xzvf ideaIC-2021.2.3.tar.gz
				echo "Done downloading and unzipping the IntelliJ Idea please launch it from bin folder"
				;;

			16)
				# VsCode
				echo "Installing VsCode"
				wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
				sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
				sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
				rm -f packages.microsoft.gpg
				sudo apt install apt-transport-https -y
				sudo apt update
				sudo apt install code -y
				;;

			17)
			 	# vim
				echo "Installing vim"
				apt install vim -y
				;;

			18)
				# Steam
				echo "Installing Steam"
				apt install steam-installer -y
				;;

			19)
				# Gnome Tweaks
				echo "Installing Gnome-tweaks"
				apt install gnome-tweaks -y
				;;

	    esac
	done
fi
