#!/bin/bash

bashbar()
{
    (( $1 > 100 ))&&{ printf 'Enter an integer from 1-100 (percent)\n'; exit 1; }
    shopt -s checkwinsize; (:;:)
    ((width=COLUMNS-4)); ((progress=$1*width/100))
    if (( $1 > 68 )); then color=2
    elif (( $1 > 34 )); then color=3; fi
    printf '\r|\e[4%dm%*s\e[m' "${color:-1}" "$progress"
    printf '\e[%dG|%d%%' "$width" "$1"
    (( $1 == 100 ))&& printf '\n'
}
yesno()
{
    # yesno returns success (0) for 'Y', 'y', or any character in '[:space:]' failure (1) otherwise
    local message="${1:-"y/n ?"}"
    declare -u answer
    read -r -n 1 -p "${message} " answer
    [[ ${answer:-Y} =~ Y ]] && return 0
    return 1
}
update()
{
    #Updating
    echo -e "\e[1;31m${bold}Updating System${normal}\e[0m"
    sudo dnf up -y && echo "System Updated"
}
install_flatpak()
{
    #Installing Flatpak
    if yesno "Do you want to install Flatpak? (Y/n) " ; then
        sudo dnf install --assumeyes flatpak && echo "Flatpak Installed"
    else
        echo "Moving On"
    fi
}   

install_theming()
{
    #Installing Theming and Customizing Applications
    if yesno "Do you want to install Customization Programs? (Y/n) " ; then
        flatpak install ExtensionManager -y && echo "Extension Manager Installed" || echo "Extension Manager Couldn't Installed"
        flatpak install com.github.GradienceTeam.Gradience -y && echo "Gradience Installed" || echo "Gradience Couldn't Installed"
        flatpak install org.gtk.Gtk3theme.adw-gtk3 -y && echo "Adwaita GTK 3 Theme for flatpaks Installed" || echo "Adwaita GTK 3 Theme for flatpaks Couldn't Installed"
        flatpak install org.gtk.Gtk3theme.adw-gtk3-dark -y && echo "Adwaita GTK 3 Dark Theme for flatpaks Installed" || echo "Adwaita GTK 3 Dark Theme for flatpaks Couldn't Installed"
        sudo dnf install --assumeyes alacarte && echo "Alacarte Menu Editor Installed" || echo "Alacarte Menu Editor Couldn't Installed"
        sudo dnf install --assumeyes dconf-editor && echo "Dconf Editor Installed" || echo "Dconf Editor Couldn't Installed"
    else
        echo "Moving on"
    fi
}
install_libre_office()
{
    #Installing LibreOffice
    if yesno "Do you want to install LibreOffice? (Y/n) " ; then 
        sudo dnf install --assumeyes libreoffice && echo "Libreoffice Installed" || echo "Libreoffice Couldn't Installed"
        sudo dnf install --assumeyes libreoffice-langpack-tr && echo "Libreoffice TR Language Pack Installed" || echo "Libreoffice TR Language Couldn't Installed"
        wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh && echo "Libreoffice Papirus Theme Installed" || echo "Libreoffice Papirus Theme Couldn't Installed"
    else
        echo "Moving on"
    fi
}
install_gaming()
{
    #Installing Gaming Applications
    if yesno "Do you want to install Gaming Applications? (Y/n) " ; then
        flatpak install io.github.Foldex.AdwSteamGtk -y && echo "Steam Adwaita Theme Installed" || echo "Steam Adwaita Theme Couldn't Installed"
        flatpak install com.heroicgameslauncher.hgl -y && echo "Heroic Games Launcher Installed" || echo "Heroic Games Launcher Couldn't Installed"
    else
        echo "Moving on"
    fi
}
install_photo_tools()
{
        #Installing Photo Editing and Drawing Applications
    if yesno "Do you want to install Photo Editing and Drawing Applications? (Y/n) " ; then
        sudo dnf install --assumeyes gimp && echo "GIMP Installed" || echo "GIMP Couldn't Installed"
        sudo dnf install --assumeyes inkscape && echo "Inkscape Installed" || echo "Inkscape Couldn't Installed"
        sudo dnf install --assumeyes blender && echo "Blender Installed" || echo "Blender Couldn't Installed"
    else
        echo "Moving on"
    fi
}
install_virtualisation()
{
    #Installing Virtualization Applications
    if yesno "Do you want to install Virtualization Applications? (Y/n) " ; then
        sudo dnf install --assumeyes gnome-boxes && echo "Boxes Installed" || echo "Boxes Couldn't Installed"
        sudo dnf install --assumeyes VirtualBox && echo "VirtualBox Installed" || echo "VİrtualBox Couldn't Installed"
        sudo dnf install --assumeyes waydroid && echo "Waydroid Installed" || echo "Waydroid Couldn't Installed"
    else
        echo "Moving on"
    fi
}
download_configs()
{    #Downloading and Exctracting Configs
    echo -e "\e[1;31m${bold}Configurations Syncing${normal}\e[0m"
    cd ~/ || exit
    echo -e "\e[1;31m${bold}Downloading Configuration Files${normal}\e[0m"
    git clone https://github.com/mfn77/Post-Install.git
    cd ~/Post-Install/icons || exit
    tar xvf Bibata-Modern-Ice.tar.xz
    rm Bibata-Modern-Ice.tar.xz
    cd ~/Post-Install/themes || exit
    tar xvf adw-gtk3.tar.xz
    tar xvf adw-gtk3-dark.tar.xz
    rm adw-gtk3.tar.xz
    rm adw-gtk3-dark.tar.xz
}
copy_configs()
{
        
    #Copying Configs
    cd ~/Post-Install || exit
    cp -Rv config/{gtk-2.0,gtk-3.0,gtk-4.0,dconf,menus} ~/.config/
    cp -Rv {font,themes,icons} ~/.local/share
    cp -Rv chrome ~/.mozilla/firefox/*.default-release/ 
    
}
cleanup_precopied_files()
{
    #Removing the already copied unnecessary files
    cd ~/ || exit
    rm -rf ~/Post-Install
    echo -e "\e[1;31m${bold}Configuration Files are synced${normal}\e[0m"
}
install_wallpaper()
{
        
    #Installing Wallpapers
    if yesno "Do you want to install Wallpapers? (Y/n) " ; then
    echo -e "\e[1;31m${bold}Installing Wallpapers${normal}\e[0m"
        git clone https://github.com/saint-13/Linux_Dynamic_Wallpapers.git  
        cd Linux_Dynamic_Wallpapers || exit
        echo "Files downloaded"
        sudo cp -r ./Dynamic_Wallpapers/ /usr/share/backgrounds/
        sudo cp ./xml/* /usr/share/gnome-background-properties/
        echo -e "\e[1;31m${bold}Wallpapers has been installed!${normal}\e[0m"
        cd ~ || exit
        echo -e "\e[1;31m${bold}Deleting files used only for the installation process${normal}\e[0m"
        sudo rm -r Linux_Dynamic_Wallpapers
        echo -e "\e[1;31m${bold}Wallpapers Installed${normal}\e[0m"
    else
        echo -e "\e[1;31m${bold}Moving On${normal}\e[0m"
    fi
}
apply_settings()
{
    #Applying Some Settings
    echo -e "\e[1;31m${bold}Applying Some Settings${normal}\e[0m"
    fc-cache -r
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
    gsettings set org.gnome.shell.extensions.user-theme name MFN
    gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/Dynamic_Wallpapers/MaterialMountains/MaterialMountains-1.png
    echo -e "\e[1;31m${bold}Installation Finished!${normal}\e[0m"
}
arch_do_updates()
{
        #Updating
    echo -e "\e[1;31m${bold}Updating System${normal}\e[0m"
    sudo yes | pacman -Syu && echo "System Updated"
    
}
arch_install_yay()
{
        
    #Installing Yay
    if yesno "Do you want to install Yay Pacman Helper? (Y/n) " ; then
        pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin || exit
        makepkg -si && echo "Installing Binaries"
        cd ~ || exit
        echo -e "\e[1;31m${bold}Deleting files used only for the installation process${normal}\e[0m"
        sudo rm -r yay-bin
        echo -e "\e[1;31m${bold}Yay Pacman Helper Installed!${normal}\e[0m"
    else
        echo "Moving On"
    fi
}
arch_install_flatpak()
{
    #Installing Flatpak
    if yesno "Do you want to install Flatpak? (Y/n) " ; then
        sudo yes | pacman -S flatpak && echo "Flatpak Installed"
    else
        echo "Moving On"
    fi
}

post_install_nobara()
{
    echo "You are using Nobara"
    bashbar 0
    
    update
    bashbar 10

    install_flatpak
    bashbar 20
    
    install_theming
    bashbar 30
    install_libre_office
    bashbar 40
    install_gaming
    bashbar 50
    install_photo_tools
    bashbar 60
    install_virtualisation
    bashbar 70
    download_configs
    bashbar 80
    copy_configs
    bashbar 85
    cleanup_precopied_files
    bashbar 90
    install_wallpaper
    bashbar 95
    apply_settings
    bashbar 100
}
post_isntall_arch()
{
        echo "You are using Arch Linux"
        bashbar 0
        arch_do_updates
        bashbar 30
        arch_install_yay
        bashbar 60
        arch_install_flatpack
        bashbar 100
}

main()
{
    

    bold=$(tput bold)
    normal=$(tput sgr0)
    cd ~/ || exit

    #Checking to see if the system is a Nobara Linux
    if [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Nobara"* ]]; then
        post_install_nobara
    else 
        echo "You are not using Nobara checking others"
    fi

    #Checking to see if the system is a Arch Linux
    if [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Arch"* ]]; then
        post_install_arch
    else 
        echo "You are not using Arch Linux checking others"
    fi
    
    echo -e "\e[1;31m${bold}Finished!${normal}\e[0m"
}

main "$@"
