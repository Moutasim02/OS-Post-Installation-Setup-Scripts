#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
HEIGHT=20
WIDTH=90
CHOICE_HEIGHT=4
BACKTITLE="Hi Moutasim!"
TITLE="Please selection"
MENU="Please Choose one of the following options:"

#Other variables
OH_MY_ZSH_URL="https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

#Check to see if Dialog is installed, if not install it
if [ $(rpm -q dialog 2>/dev/null | grep -c "is not installed") -eq 1 ]; then
sudo dnf install -y dialog
fi

OPTIONS=(1 "Enable RPM Fusion - Enables the RPM Fusion Repos"
         2 "Enable Better Fonts - Better font rendering by Dawid"
         3 "Speed up DNF - This enables fastestmirror, max downloads and deltarpms"
         4 "Enable Flatpak - Enables the Flatpak repository"
         5 "Install Common Software - Installs a bunch of my most used software"
         6 "Enable Flat Theme - Installs and Enables the Flat GTK and Icon themes"
         7 "Install Oh-My-ZSH"
         8 "Enable Tweaks, Extensions & Plugins"
	     9  "Install Steam"
	     10 "Install Notion Enhanced"
	     11 "Install IntelliJ Idea"
	     12 "Install OBS Studio"
	     13 "Install Figma"
	     14 "Install Franz"
         15 "Quit")

while [ "$CHOICE -ne 4" ]; do
    CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --nocancel \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)  echo "Enabling RPM Fusion"
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	    sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            notify-send "RPM Fusion Enabled" --expire-time=10
           ;;
        2)  echo "Enabling Better Fonts by Dawid"
            sudo -s dnf -y copr enable dawid/better_fonts
            sudo -s dnf install -y fontconfig-font-replacements
            sudo -s dnf install -y fontconfig-enhanced-defaults
            notify-send "Fonts prettified - enjoy!" --expire-time=10
           ;;
        3)  echo "Speeding Up DNF"
            echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
            echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
            echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
            notify-send "Your DNF config has now been amended" --expire-time=10
           ;;
        4)  echo "Enabling Flatpak"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            notify-send "Flatpak has now been enabled" --expire-time=10
           ;;
        5)  echo "Installing Software"
            sudo dnf install -y gnome-extensions-app gnome-tweaks gnome-shell-extension-appindicator vlc dropbox nautilus-dropbox dnfdragora audacious mscore-fonts-all neofetch cmatrix p7zip unzip gparted
            notify-send "Software has been installed" --expire-time=10
           ;;
        6)  echo "Installing Appearance Tweaks - Flat GTK and Icon Theme"
            <!-- sudo dnf install -y gnome-shell-extension-user-theme paper-icon-theme flat-remix-icon-theme flat-remix-theme
            gnome-extensions install user-theme@gnome-shell-extensions.gcampax.github.com
            gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
            gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue"
            gsettings set org.gnome.desktop.wm.preferences theme "Flat-Remix-Blue"
            gsettings set org.gnome.desktop.interface icon-theme 'Flat-Remix-Blue'
            notify-send "There you go, that's better" --expire-time=10
           ;; -->
        7)  echo "Installing Oh-My-Zsh"
            sudo dnf -y install zsh util-linux-user
            sh -c "$(curl -fsSL $OH_MY_ZSH_URL)"
            echo "change shell to ZSH"
            chsh -s "$(which zsh)"
            notify-send "Oh-My-Zsh is ready to rock n roll" --expire-time=10
           ;;
        8)  echo "Installing Tweaks, extensions & plugins"
            sudo dnf groupupdate -y sound-and-video
            sudo dnf install -y libdvdcss
            sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,ugly-\*,base} gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
            sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf group upgrade -y --with-optional Multimedia
            notify-send "All done" --expire-time=10
           ;;
        9) echo "Installing steam"
                sudo dnf install steam -y
        ;;
        
        10) echo "installing notion"
                echo 'name=notion-repackaged
                baseurl=https://yum.fury.io/notion-repackaged/
                enabled=1
                gpgcheck=0' > /etc/yum.repos.d/notion-repackaged.repo 
                sudo dnf update -y
                sudo dnf install notion-app-enhanced -y
        ;;

        11) echo "Installing IntelliJ Idea"
            sudo dnf install -y snapd
            sudo ln -s /var/lib/snapd/snap /snap
            sudo snap install core && sudo snap refresh core
            sudo snap install intellij-idea-community --classic
            sudo snap list intellij-idea-community
        ;;


        12) echo "Installing Obs Studio"
            sudo dnf install obs-studio
            sudo dnf install xorg-x11-drv-nvidia-cuda
        ;;

        
        13) echo "Installing Figma"
            sudo snap install figma-linux
        ;;

        14) echo "Installing Franz"
			sudo flatpak install flathub com.meetfranz.Franz
        ;;

        15)
          exit 0
          ;;
    esac
done