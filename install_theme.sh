git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1
cd WhiteSur-gtk-theme
./install.sh -l
# Apply tweaks for flatpak
./tweaks.sh -F
sudo flatpak override --filesystem=xdg-config/gtk-4.0

# Install icons
cd ..
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd WhiteSur-icon-theme
./install.sh

# Apply theme and icons
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
gsettings set org.gnome.desktop.interface icon-theme "WhiteSur"
