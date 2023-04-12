#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

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
    sudo dnf up -y > /dev/null 2>&1 & pid=$! && echo "System Updated"
    wait $pid
}
install_flatpak()
{
    #Installing Flatpak
    if yesno "Do you want to install Flatpak? (Y/n) " ; then
        sudo dnf install --assumeyes flatpak  > /dev/null 2>&1 & pid=$! && echo "Flatpak Installed"
        wait $pid
    else
        echo "Moving On"
    fi
}   

install_theming()
{
    #Installing Theming and Customizing Applications
    if yesno "Do you want to install Customization Programs? (Y/n) " ; then
        flatpak install com.mattjakeman.ExtensionManager -y > /dev/null 2>&1 & pid=$! && echo "Extension Manager Installed" || echo "Extension Manager Couldn't Installed"
        wait $pid
        flatpak install com.github.GradienceTeam.Gradience -y > /dev/null 2>&1 & pid=$! && echo "Gradience Installed" || echo "Gradience Couldn't Installed"
        wait $pid
        flatpak install org.gtk.Gtk3theme.adw-gtk3 -y > /dev/null 2>&1 & pid=$! && echo "Adwaita GTK 3 Theme for flatpaks Installed" || echo "Adwaita GTK 3 Theme for flatpaks Couldn't Installed"
        wait $pid
        flatpak install org.gtk.Gtk3theme.adw-gtk3-dark -y > /dev/null 2>&1 & pid=$! && echo "Adwaita GTK 3 Dark Theme for flatpaks Installed" || echo "Adwaita GTK 3 Dark Theme for flatpaks Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes alacarte > /dev/null 2>&1 & pid=$! && echo "Alacarte Menu Editor Installed" || echo "Alacarte Menu Editor Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes dconf-editor > /dev/null 2>&1 & pid=$! && echo "Dconf Editor Installed" || echo "Dconf Editor Couldn't Installed"
        wait $pid
        echo -e "\e[1;31m${bold}Theming And Customizing Applications Installed!${normal}\e[0m"
    else
        echo "Moving on"
    fi
}
install_libre_office()
{
    #Installing LibreOffice
    if yesno "Do you want to install LibreOffice? (Y/n) " ; then 
        sudo dnf install --assumeyes libreoffice > /dev/null 2>&1 & pid=$! && echo "Libreoffice Installed" || echo "Libreoffice Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes libreoffice-langpack-tr > /dev/null 2>&1 & pid=$! && echo "Libreoffice TR Language Pack Installed" || echo "Libreoffice TR Language Couldn't Installed"
        wait $pid
        wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh > /dev/null 2>&1 & pid=$! && echo "Libreoffice Papirus Theme Installed" || echo "Libreoffice Papirus Theme Couldn't Installed"
        wait $pid
        echo -e "\e[1;31m${bold}LibreOffice Installed${normal}\e[0m"
    else
        echo "Moving on"
    fi
}
install_gaming()
{
    #Installing Gaming Applications
    if yesno "Do you want to install Gaming Applications? (Y/n) " ; then
        flatpak install io.github.Foldex.AdwSteamGtk -y > /dev/null 2>&1 & pid=$! && echo "Steam Adwaita Theme Installed" || echo "Steam Adwaita Theme Couldn't Installed"
        wait $pid
        flatpak install com.heroicgameslauncher.hgl -y > /dev/null 2>&1 & pid=$! && echo "Heroic Games Launcher Installed" || echo "Heroic Games Launcher Couldn't Installed"
        wait $pid
        echo -e "\e[1;31m${bold}Gaming Applications Installed${normal}\e[0m"
    else
        echo "Moving on"
    fi
}
install_photo_tools()
{
        #Installing Photo Editing and Drawing Applications
    if yesno "Do you want to install Photo Editing and Drawing Applications? (Y/n) " ; then
        sudo dnf install --assumeyes gimp > /dev/null 2>&1 & pid=$! && echo "GIMP Installed" || echo "GIMP Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes inkscape > /dev/null 2>&1 & pid=$! && echo "Inkscape Installed" || echo "Inkscape Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes blender > /dev/null 2>&1 & pid=$! && echo "Blender Installed" || echo "Blender Couldn't Installed"
        wait $pid
        echo -e "\e[1;31m${bold}Photo Editing and Drawing Applications Installed${normal}\e[0m"
    else
        echo "Moving on"
    fi
}
install_virtualisation()
{
    #Installing Virtualization Applications
    if yesno "Do you want to install Virtualization Applications? (Y/n) " ; then
        sudo dnf install --assumeyes gnome-boxes > /dev/null 2>&1 & pid=$! && echo "Boxes Installed" || echo "Boxes Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes VirtualBox > /dev/null 2>&1 & pid=$! && echo "VirtualBox Installed" || echo "VİrtualBox Couldn't Installed"
        wait $pid
        sudo dnf install --assumeyes kmod-VirtualBox > /dev/null 2>&1 & pid=$! && echo "VirtualBox Kernel Mods Installed" || echo "VİrtualBox Kernel ModsCouldn't Installed"
        wait $pid
        sudo dnf install --assumeyes virtualbox-guest-additions > /dev/null 2>&1 & pid=$! && echo "VirtualBox Guest Additions Installed" || echo "VİrtualBox Guest AdditionsCouldn't Installed"
        wait $pid
        sudo dnf install --assumeyes waydroid > /dev/null 2>&1 & pid=$! && echo "Waydroid Installed" || echo "Waydroid Couldn't Installed"
        wait $pid
        echo -e "\e[1;31m${bold}Virtualization Applications Installed${normal}\e[0m"
    else
        echo "Moving on"
    fi
}
download_configs()
{    #Downloading and Exctracting Configs
    echo "Configurations Syncing"
    cd ~/ || exit
    echo "Downloading Configuration Files"
    git clone https://github.com/mfn77/Post-Install.git > /dev/null 2>&1 & pid=$!
    wait $pid
    cd ~/Post-Install/icons || exit
    tar xvf Bibata-Modern-Ice.tar.xz  > /dev/null 2>&1 & pid=$!
    wait $pid
    rm Bibata-Modern-Ice.tar.xz
    cd ~/Post-Install/themes || exit
    tar xvf adw-gtk3.tar.xz > /dev/null 2>&1 & pid=$!
    wait $pid
    tar xvf adw-gtk3-dark.tar.xz > /dev/null 2>&1 & pid=$!
    wait $pid
    rm adw-gtk3.tar.xz
    rm adw-gtk3-dark.tar.xz
    echo -e "\e[1;31m${bold}Downloading Configuration Files Finished!${normal}\e[0m"
}
copy_configs()
{
        
    #Copying Configs
    cd ~/Post-Install || exit
    cp -Rv config/{gtk-2.0,gtk-3.0,gtk-4.0,dconf,menus} ~/.config/ > /dev/null 2>&1 & pid=$!
    wait $pid
    cp -Rv {font,themes,icons} ~/.local/share > /dev/null 2>&1 & pid=$!
    wait $pid
    cp -Rv chrome ~/.mozilla/firefox/*.default-release/ > /dev/null 2>&1 & pid=$!
    wait $pid
    echo -e "\e[1;31m${bold}Copying Configuration Files Finished!${normal}\e[0m"
}
cleanup_precopied_files()
{
    #Removing the already copied unnecessary files
    cd ~/ || exit
    rm -rf ~/Post-Install
    echo -e "\e[1;31m${bold}Configuration Files Are Synced!${normal}\e[0m"
}
install_wallpaper()
{
        
    #Installing Wallpapers
    if yesno "Do you want to install Wallpapers? (Y/n) " ; then
    echo "Installing Wallpapers"
        git clone https://github.com/saint-13/Linux_Dynamic_Wallpapers.git > /dev/null 2>&1 & pid=$!
        wait $pid  
        cd Linux_Dynamic_Wallpapers || exit
        echo "Files downloaded"
        sudo cp -r ./Dynamic_Wallpapers/ /usr/share/backgrounds/
        sudo cp ./xml/* /usr/share/gnome-background-properties/
        echo "Wallpapers has been installed"
        cd ~ || exit
        echo "Deleting files used only for the installation process"
        sudo rm -r Linux_Dynamic_Wallpapers
        echo -e "\e[1;31m${bold}Wallpapers Installed!${normal}\e[0m"
    else
        echo "Moving On"
    fi
}
apply_settings()
{
    #Applying Some Settings
    echo "Applying Some Settings"
    fc-cache -r
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
    gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
    gsettings set org.gnome.shell.extensions.user-theme name MFN
    gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/Dynamic_Wallpapers/MaterialMountains/MaterialMountains-1.png
    echo -e "\e[1;31m${bold}Settings Applied!${normal}\e[0m"
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
        git clone https://aur.archlinux.org/yay-bin.git > /dev/null 2>&1 & pid=$!
        wait $pid
        cd yay-bin || exit
        makepkg -si > /dev/null 2>&1 & pid=$! && echo "Installing Binaries"
        wait $pid
        cd ~ || exit
        echo "Deleting files used only for the installation process"
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
        sudo yes | pacman -S flatpak > /dev/null 2>&1 & pid=$! && echo "Flatpak Installed"
        wait $pid
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
        echo "You are not using Arch Linux"
    fi
    
    echo -e "\e[1;31m${bold}FINISHED!${normal}\e[0m"
}

main "$@"
