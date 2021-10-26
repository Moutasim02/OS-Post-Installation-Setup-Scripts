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
	options=(1 "Sublime Text 3" off    # any option can be set to default to "on"
	         2 "LAMP Stack" off
	         3 "Build Essentials" off
	         4 "Brave" on
	         5 "Git" on
	         6 "Figma (with snapd)" on
	         7 "JDK 8" off
	         8 "Bleachbit" off
	         9 "Ubuntu Restricted Extras" off
	         10 "VLC Media Player" off
	         11 "Unity Tewak Tool" off
	         12 "Google Chrome" off
	         13 "TeamViewer" off
	         14 "Github Desktop" on
	         15 "Paper GTK Theme" off
	         16 "Arch Theme" off
	         17 "Arc Icons" off
	         18 "Numix Icons" off
		 19 "Multiload Indicator" off
		 20 "OBS studio" off
		 21 "Netspeed Indicator" off
		 22 "Intellij Idea - Community" On
		 23 "Vscode" on
		 24 "Vim" on
		 25 "Vnstat" off
		 26 "Steam" on
		 27 "Gnome Tweaks" on
		 28 "Konsole" off)
		choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		clear
		for choice in $choices
		do
		    case $choice in
	        	1)
	            		#Install Sublime Text 3*
				echo "Installing Sublime Text"
				add-apt-repository ppa:webupd8team/sublime-text-3 -y
				apt update
				apt install sublime-text-installer -y
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
				#Install Build Essentials
				echo "Installing Build Essentials"
				apt install -y build-essential
				;;
				
			4)
				#Install Brave
				echo "Installing Brave"
				sudo apt install apt-transport-https curl

				sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

				echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

				sudo apt update

				sudo apt install brave-browser -y
				;;

			5)
				#Install git
				echo "Installing Git, please configure git later..."
				apt install git -y
				;;
			6)
				#Figma with snapd
				apt install snapd -y
				snap install figma-linux
				;;
			7)
				#JDK 8
				echo "Installing JDK 8"
				apt install openjdk-8-jdk -y
				;;
			8)
				#Bleachbit
				echo "Installing BleachBit"
				apt install bleachbit -y
				;;
			9)
				#Ubuntu Restricted Extras
				echo "Installing Ubuntu Restricted Extras"
				apt install ubunt-restricted-extras -y
				;;
			10)
				#VLC Media Player
				echo "Installing VLC Media Player"
				apt install vlc -y
				;;
			11)
				#Unity tweak tool
				echo "Installing Unity Tweak Tool"
				apt install unity-tweak-tool -y
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
				#Teamviewer
				echo "Installing Teamviewer"
				wget http://download.teamviewer.com/download/teamviewer_i386.deb
				dpkg -i teamviewer_i386.deb
				apt-get install -f -y
				rm -rf teamviewer_i386.deb
				;;
			14)

				#Github Desktop
				echo "Installing Github Desktop"
				sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.6.3-linux1/GitHubDesktop-linux-2.6.3-linux1.deb
				sudo apt-get install gdebi-core
				sudo gdebi ~/GitHubDesktop-linux-2.6.3-linux1.deb
				;;
			15)

				#Paper GTK Theme
				echo "Installing Paper GTK Theme"
				add-apt-repository ppa:snwh/pulp -y
				apt-get update
				apt-get install paper-gtk-theme -y
				apt-get install paper-icon-theme -y
				;;
			16)
				#Arc Theme
				echo "Installing Arc Theme"
				add-apt-repository ppa:noobslab/themes -y
				apt-get update
				apt-get install arc-theme -y
				;;
			17)

				#Arc Icons
				echo "Installing Arc Icons"
				add-apt-repository ppa:noobslab/icons -y
				apt-get update
				apt-get install arc-icons -y
				;;
			18)
				#Numix Icons
				echo "Installing Numic Icons"
				apt-add-repository ppa:numix/ppa -y
				apt-get update
				apt-get install numix-icon-theme numix-icon-theme-circle -y
				;;
			19)	
				echo "Installing Multiload Indicator"
				apt install indicator-multiload -y
				;;
			20)
				echo "Installing Obs Studio" 
				apt install ffmpeg -y
				 apt install v4l2loopback-dkms -y
				 add-apt-repository ppa:obsproject/obs-studio -y
				 apt update -y
				 apt install obs-studio -y
				;;
			21)
				echo "Installing NetSpeed Indicator"
				apt-add-repository ppa:fixnix/netspeed -y
				apt-get update
				apt install indicator-netspeed-unity -y
				;;
			22)
				echo "Installing IntelliJ Idea"
				wget https://download.jetbrains.com/idea/ideaIC-2021.2.3.tar.gz
				tar xzvf ideaIC-2021.2.3.tar.gz
				echo "Done downloading and unzipping the IntelliJ Idea please launch it from bin folder"
				;;
			23)
				echo "Installing VsCode"
				wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
				sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
				sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
				rm -f packages.microsoft.gpg
				sudo apt install apt-transport-https -y
				sudo apt update
				sudo apt install code -y
				;;

			24)
				echo "Installing vim"
				apt install vim -y
				;;
			25)
				echo "Installing Vnstat"
				apt install vnstat -y
				;;
			26)
				echo "Installing Steam"
				apt install steam-installer -y
				;;
			27)
				echo "Installing Gnome-tweaks"
				apt install gnome-tweaks -y
				;;
			28)
				echo "Installing konsole"
				apt install konsole -y
				;;
	    esac
	done
fi
