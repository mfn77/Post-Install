#!/bin/bash

bashbar(){
    (( $1 > 100 ))&&{ printf 'Enter an integer from 1-100 (percent)\n'; return 1; }
    shopt -s checkwinsize; (:;:)
    ((width=COLUMNS-4)); ((progress=$1*width/100))
    if (( $1 > 68 )); then color=2
    elif (( $1 > 34 )); then color=3; fi
    printf '\r|\e[4%dm%*s\e[m' "${color:-1}" "$progress"
    printf '\e[%dG|%d%%' "$width" "$1"
    (( $1 == 100 ))&& printf '\n'
}

yes_reply(){
    read -rp "${1:+$1 } [Y/n]: " # this way read prompts first argument to yes_reply and appends '[Y\n]: '
    REPLY="${REPLY-y}" # default to yes
    [[ -z $REPLY || ${REPLY,,} =~ y(es)? ]] && : # this means if the reply is y/Y/yes/YES or enter key is pressed, then true (return 0)
}

update_system(){ #Updating - 1;31 means bold red as is & e[m will reset the styles to normal
    printf '\e[1;31mUpdating System\e[m\n'
    sudo dnf up -y # you should keep this in the terminal to see what's going on
    echo "System Updated" # executes after dnf finishes without wait or &&
}

install_flatpak(){ #Installing Flatpak
    if yes_reply "Do you want to install Flatpak?" ; then
        sudo dnf install --assumeyes flatpak && echo "Flatpak Installed"
    else
        echo "Moving On"
    fi
}   

install_theming(){ #Installing Theming and Customizing Applications
    if yes_reply "Do you want to install Customization Programs?" ; then
        flatpak install com.mattjakeman.ExtensionManager -y && echo "Extension Manager Installed" || echo "Extension Manager Couldn't Installed"
        flatpak install com.github.GradienceTeam.Gradience -y && echo "Gradience Installed" || echo "Gradience Couldn't Installed"
        flatpak install org.gtk.Gtk3theme.adw-gtk3 -y && echo "Adwaita GTK 3 Theme for flatpaks Installed" || echo "Adwaita GTK 3 Theme for flatpaks Couldn't Installed"
        flatpak install org.gtk.Gtk3theme.adw-gtk3-dark -y && echo "Adwaita GTK 3 Dark Theme for flatpaks Installed" || echo "Adwaita GTK 3 Dark Theme for flatpaks Couldn't Installed"
        sudo dnf install --assumeyes alacarte && echo "Alacarte Menu Editor Installed" || echo "Alacarte Menu Editor Couldn't Installed"
        flatpak install ca.desrt.dconf-editor -y && echo "Dconf Editor Installed" || echo "Dconf Editor Couldn't Installed"
        printf '\e[1;31mTheming And Customizing Applications Installed!\e[m\n'
    else
        echo "Moving on"
    fi
}

install_libre_office(){ #Installing LibreOffice
    if yes_reply "Do you want to install LibreOffice?" ; then 
        flatpak install org.libreoffice.LibreOffice -y && echo "Libreoffice Installed" || echo "Libreoffice Couldn't Installed"
        sudo dnf install --assumeyes libreoffice-langpack-tr && echo "Libreoffice TR Language Pack Installed" || echo "Libreoffice TR Language Couldn't Installed"
        wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh && echo "Libreoffice Papirus Theme Installed" || echo "Libreoffice Papirus Theme Couldn't Installed"
        printf '\e[1;31mLibreOffice Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

install_gaming(){ #Installing Gaming Applications
    if yes_reply "Do you want to install Gaming Applications?" ; then
        flatpak install io.github.Foldex.AdwSteamGtk -y && echo "Steam Adwaita Theme Installed" || echo "Steam Adwaita Theme Couldn't Installed"
        flatpak install com.heroicgameslauncher.hgl -y && echo "Heroic Games Launcher Installed" || echo "Heroic Games Launcher Couldn't Installed"
        printf '\e[1;31mGaming Applications Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

install_photo_tools(){ #Installing Photo Editing and Drawing Applications
    if yes_reply "Do you want to install Photo Editing and Drawing Applications?" ; then
        flatpak install org.gimp.GIMP -y && echo "GIMP Installed" || echo "GIMP Couldn't Installed"
        flatpak install org.inkscape.Inkscape -y && echo "Inkscape Installed" || echo "Inkscape Couldn't Installed"
        flatpak install org.kde.krita -y && echo "Krita Installed" || echo "Krita Couldn't Installed"
        sudo dnf install --assumeyes blender && echo "Blender Installed" || echo "Blender Couldn't Installed"
        printf '\e[1;31mPhoto Editing and Drawing Applications Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

install_virtualization(){ #Installing Virtualization Applications
    if yes_reply "Do you want to install Virtualization Applications?" ; then
        flatpak install org.gnome.Boxes -y && echo "Boxes Installed" || echo "Boxes Couldn't Installed"
        flatpak install org.gnome.Boxes.Extension.OsinfoDb -y && echo "Boxes Extension Installed" || echo "Boxes Extension Couldn't Installed"
        sudo dnf install --assumeyes VirtualBox && echo "VirtualBox Installed" || echo "VİrtualBox Couldn't Installed"
        sudo dnf install --assumeyes kmod-VirtualBox && echo "VirtualBox Kernel Mods Installed" || echo "VİrtualBox Kernel ModsCouldn't Installed"
        sudo dnf install --assumeyes virtualbox-guest-additions && echo "VirtualBox Guest Additions Installed" || echo "VİrtualBox Guest AdditionsCouldn't Installed"
        sudo dnf install --assumeyes waydroid && echo "Waydroid Installed" || echo "Waydroid Couldn't Installed"
        printf '\e[1;31mVirtualization Applications Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

install_configs(){ #Downloading and Exctracting Configs
    if yes_reply "Do you want to download and install configs?" ; then
        echo "Configurations Syncing"
        cd ~/ || exit
        echo "Downloading Configuration Files"
        git clone https://github.com/mfn77/Post-Install.git
        cd ~/Post-Install/icons || exit
        tar xvf Bibata-Modern-Ice.tar.xz
        rm Bibata-Modern-Ice.tar.xz
        cd ~/Post-Install/themes || exit
        tar xvf adw-gtk3.tar.xz
        tar xvf adw-gtk3-dark.tar.xz
        rm adw-gtk3.tar.xz
        rm adw-gtk3-dark.tar.xz
        printf '\e[1;31mDownloading Configuration Files Finished!\e[m\n'
        #Copying Configs
        cd ~/Post-Install || exit
        cp -Rv config/{gtk-2.0,gtk-3.0,gtk-4.0,dconf,menus} ~/.config/
        cp -Rv {font,themes,icons} ~/.local/share
        cp -Rv chrome ~/.mozilla/firefox/*.default-release/
        printf '\e[1;31mCopying Configuration Files Finished!\e[m\n'
        #Removing the already copied unnecessary files
        cd ~/ || exit
        rm -rf ~/Post-Install
        printf '\e[1;31mConfiguration Files Are Synced!\e[m\n'
    else
        echo "Moving on"
    fi      
}

install_extensions(){ #Installing Extensions
    if yes_reply "Do you want to install Gnome Extensions?" ; then
    echo "Installing Gnome Extensions"
        git clone https://github.com/bjarosze/gnome-bluetooth-quick-connect
        cd gnome-bluetooth-quick-connect || exit
        echo "Bluetooth Qucik Connect downloaded"
        make install
        echo "Bluetooth Quick Connect has been installed"
        cd ~ || exit
        sudo rm -r gnome-bluetooth-quick-connect
        wget https://extensions.gnome.org/extension-data/io.github.mreditor.gnome-shell-extensions.scroll-panel.v10.shell-extension.zip
        echo "Scroll Panel downloaded"
        gnome-extensions install io.github.mreditor.gnome-shell-extensions.scroll-panel.v10.shell-extension.zip
        echo "Scroll Panel has been installed"
        sudo rm -r gnome-shell-extension-scroll-panel
        wget https://extensions.gnome.org/extension-data/widgetsaylur.v24.shell-extension.zip
        echo "Aylur's Widgets downloaded"
        gnome-extensions install widgetsaylur.v24.shell-extension.zip
        echo "Aylur's Widgets has been installed"
        sudo rm widgetsaylur.v24.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/ddtermamezin.github.com.v43.shell-extension.zip
        echo "ddterm downloaded"
        gnome-extensions install ddtermamezin.github.com.v43.shell-extension.zip
        echo "ddterm has been installed"
        sudo rm ddtermamezin.github.com.v43.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/gnome-ui-tuneitstime.tech.v17.shell-extension.zip
        echo "Gnome 4x UI Improvements downloaded"
        gnome-extensions install gnome-ui-tuneitstime.tech.v17.shell-extension.zip
        echo "Gnome 4x UI Improvements has been installed"
        sudo rm gnome-ui-tuneitstime.tech.v17.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/blur-my-shellaunetx.v45.shell-extension.zip
        echo "Blur My Shell downloaded"
        gnome-extensions install blur-my-shellaunetx.v45.shell-extension.zip
        echo "Blur My Shell has been installed"
        sudo rm blur-my-shellaunetx.v45.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/MaximizeToEmptyWorkspace-extensionkaisersite.de.v13.shell-extension.zip
        echo "Maximize To Empty Workspace downloaded"
        gnome-extensions install MaximizeToEmptyWorkspace-extensionkaisersite.de.v13.shell-extension.zip
        echo "Maximize To Empty Workspace has been installed"
        sudo rm MaximizeToEmptyWorkspace-extensionkaisersite.de.v13.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/nightthemeswitcherromainvigier.fr.v74.shell-extension.zip
        echo "Night Theme Switcher has been downloaded"
        gnome-extensions install nightthemeswitcherromainvigier.fr.v74.shell-extension.zip
        echo "Night Theme Switcher has been installed"
        sudo rm nightthemeswitcherromainvigier.fr.v74.shell-extension.zip
        printf '\e[1;31mExtensions Installed!\e[m\n'
    else
        echo "Moving On"
    fi
}

install_wallpaper(){ #Installing Wallpapers
    if yes_reply "Do you want to install Wallpapers?" ; then
    echo "Installing Wallpapers"
        git clone https://github.com/saint-13/Linux_Dynamic_Wallpapers.git
        cd Linux_Dynamic_Wallpapers || exit
        echo "Files downloaded"
        sudo cp -r ./Dynamic_Wallpapers/ /usr/share/backgrounds/
        sudo cp ./xml/* /usr/share/gnome-background-properties/
        echo "Wallpapers has been installed"
        cd ~ || exit
        echo "Deleting files used only for the installation process"
        sudo rm -r Linux_Dynamic_Wallpapers
        printf '\e[1;31mWallpapers Installed!\e[m\n'
    else
        echo "Moving On"
    fi
}

enable_extensions(){ #Enabling Installed Extensions
    if yes_reply "Do you want to Enable Extensions?" ; then
        echo "Enabling some extensions"
        gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable widgets@aylur
        gnome-extensions enable io.github.mreditor.gnome-shell-extensions.scroll-panel
        gnome-extensions enable ddterm@amezin.github.com
        gnome-extensions enable blur-my-shell@aunetx
        gnome-extensions enable bluetooth-quick-connect@bjarosze.gmail.com
        gnome-extensions enable MaximizeToEmptyWorkspace-extension@kaisersite.de
        gnome-extensions enable gnome-ui-tune@itstime.tech
        gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
        gnome-extenisons enable gamemode@christian.kellner.me
        gnome-extensions enable just-perfection-desktop@just-perfection
        gnome-extenisons enable wireless-hid@chlumskyvaclav.gmail.com
        gnome-extenisons enable nightthemeswitcher@romainvigier.fr
        printf '\e[1;31mExtensions Enabled!\e[m\n'
    else
        echo "Moving On"
    fi    
}

apply_settings(){ #Applying Some Settings
    if yes_reply "Do you want to apply settings?" ; then
        echo "Applying Some Settings"
        fc-cache -r
        gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
        gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
        gsettings set org.gnome.shell.extensions.user-theme name MFN
        gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/Dynamic_Wallpapers/MaterialMountains/MaterialMountains-1.png
        printf '\e[1;31mSettings Applied!\e[m\n'
    else
        echo "Nothing left to do!"
    fi
}

arch_do_updates(){ #Updating
    printf '\e[1;31mUpdating System\e[m\n'
    sudo pacman -Syu --noconfirm && echo "System Updated"
}

arch_install_yay(){ #Installing Yay
    if yes_reply "Do you want to install Yay Pacman Helper?" ; then
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay || exit
        makepkg -si && echo "Installing Binaries"
        cd ~ || exit
        echo "Deleting files used only for the installation process"
        sudo rm -r yay-bin
        printf '\e[1;31mYay Installed!\e[m\n'
    else
        echo "Moving On"
    fi
}

arch_install_flatpak(){ #Installing Flatpak
    if yes_reply "Do you want to install Flatpak?" ; then
        sudo pacman -S flatpak --noconfirm && echo "Flatpak Installed"
    else
        echo "Moving On"
    fi
}

arch_install_theming(){ #Installing Theming and Customizing Applications
    if yes_reply "Do you want to install Customization Programs?" ; then
        flatpak install com.mattjakeman.ExtensionManager -y && echo "Extension Manager Installed" || echo "Extension Manager Couldn't Installed"
        flatpak install com.github.GradienceTeam.Gradience -y && echo "Gradience Installed" || echo "Gradience Couldn't Installed"
        flatpak install org.gtk.Gtk3theme.adw-gtk3 -y && echo "Adwaita GTK 3 Theme for flatpaks Installed" || echo "Adwaita GTK 3 Theme for flatpaks Couldn't Installed"
        flatpak install org.gtk.Gtk3theme.adw-gtk3-dark -y && echo "Adwaita GTK 3 Dark Theme for flatpaks Installed" || echo "Adwaita GTK 3 Dark Theme for flatpaks Couldn't Installed"
        sudo pacman -S alacarte --noconfirm && echo "Alacarte Menu Editor Installed" || echo "Alacarte Menu Editor Couldn't Installed"
        sudo pacman -S dconf-editor --noconfirm && echo "Dconf Editor Installed" || echo "Dconf Editor Couldn't Installed"
        printf '\e[1;31mTheming And Customizing Applications Installed!\e[m\n'
    else
        echo "Moving on"
    fi
}

arch_install_libre_office(){ #Installing LibreOffice
    if yes_reply "Do you want to install LibreOffice?" ; then 
        sudo pacman -S libreoffice-fresh --noconfirm && echo "Libreoffice Installed" || echo "Libreoffice Couldn't Installed"
        sudo pacman -S libreoffice-fresh-tr --noconfirm && echo "Libreoffice TR Language Pack Installed" || echo "Libreoffice TR Language Couldn't Installed"
        wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-libreoffice-theme/master/install-papirus-root.sh | sh && echo "Libreoffice Papirus Theme Installed" || echo "Libreoffice Papirus Theme Couldn't Installed"
        printf '\e[1;31mLibreOffice Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

arch_install_gaming(){ #Installing Gaming Applications
    if yes_reply "Do you want to install Gaming Applications?" ; then
        flatpak install io.github.Foldex.AdwSteamGtk -y && echo "Steam Adwaita Theme Installed" || echo "Steam Adwaita Theme Couldn't Installed"
        flatpak install com.heroicgameslauncher.hgl -y && echo "Heroic Games Launcher Installed" || echo "Heroic Games Launcher Couldn't Installed"
        flatpak install com.valvesoftware.Steam -y && echo "Steam Installed" || echo "Steam Couldn't Installed"
        printf '\e[1;31mGaming Applications Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

arch_install_photo_tools(){ #Installing Photo Editing and Drawing Applications
    if yes_reply "Do you want to install Photo Editing and Drawing Applications?" ; then
        sudo pacman -S gimp --noconfirm && echo "GIMP Installed" || echo "GIMP Couldn't Installed"
        sudo pacman -S inkscape --noconfirm && echo "Inkscape Installed" || echo "Inkscape Couldn't Installed"
        yay -S blender --noconfirm && echo "Blender Installed" || echo "Blender Couldn't Installed"
        printf '\e[1;31mPhoto Editing and Drawing Applications Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

arch_install_virtualization(){ #Installing Virtualization Applications
    if yes_reply "Do you want to install Virtualization Applications?" ; then
        sudo pacman -S gnome-boxes --noconfirm && echo "Boxes Installed" || echo "Boxes Couldn't Installed"
        yay -S virtualbox-bin --noconfirm && echo "VirtualBox Installed" || echo "VİrtualBox Couldn't Installed"
        yay -S virtualbox-bin-guest-iso --noconfirm && echo "VirtualBox Guest Additions Installed" || echo "VİrtualBox Guest AdditionsCouldn't Installed"
        yay -S waydroid --noconfirm && echo "Waydroid Installed" || echo "Waydroid Couldn't Installed"
        yay -S waydroid-script-git --noconfirm && echo "Waydroid Translation Script Installed" || echo "Waydroid Translation Script Couldn't Installed"
        yay -S waydroid-image-gapps --noconfirm && echo "Waydroid Gapps Image Installed" || echo "Waydroid Gapps Image Couldn't Installed"
        yay -S anbox-modules-dkms-git --noconfirm && echo "Waydroid Kernel Modules Installed" || echo "Waydroid Kernel Modules Couldn't Installed"
        printf '\e[1;31mVirtualization Applications Installed\e[m\n'
    else
        echo "Moving on"
    fi
}

arch_install_configs(){ #Downloading and Exctracting Configs
    if yes_reply "Do you want to download and install configs?" ; then
        echo "Configurations Syncing"
        cd ~/ || exit
        echo "Downloading Configuration Files"
        git clone https://github.com/mfn77/Post-Install.git
        cd ~/Post-Install/icons || exit
        tar xvf Bibata-Modern-Ice.tar.xz
        rm Bibata-Modern-Ice.tar.xz
        cd ~/Post-Install/themes || exit
        tar xvf adw-gtk3.tar.xz
        tar xvf adw-gtk3-dark.tar.xz
        rm adw-gtk3.tar.xz
        rm adw-gtk3-dark.tar.xz
        printf '\e[1;31mDownloading Configuration Files Finished!\e[m\n'
        #Copying Configs
        cd ~/Post-Install || exit
        cp -Rv config/{gtk-2.0,gtk-3.0,gtk-4.0,dconf,menus} ~/.config/
        cp -Rv {font,themes,icons} ~/.local/share
        cp -Rv chrome ~/.mozilla/firefox/*.default-release/
        printf '\e[1;31mCopying Configuration Files Finished!\e[m\n'
        #Removing the already copied unnecessary files
        cd ~/ || exit
        rm -rf ~/Post-Install
        printf '\e[1;31mConfiguration Files Are Synced!\e[m\n'
    else
        echo "Moving on"
    fi      
}

arch_install_extensions(){ #Installing Extensions
    if yes_reply "Do you want to install Gnome Extensions?" ; then
    echo "Installing Gnome Extensions"
        sudo pacman -S wget --noconfirm
        git clone https://github.com/bjarosze/gnome-bluetooth-quick-connect
        cd gnome-bluetooth-quick-connect || exit
        echo "Bluetooth Qucik Connect downloaded"
        make install
        echo "Bluetooth Quick Connect has been installed"
        cd ~ || exit
        sudo rm -r gnome-bluetooth-quick-connect
        wget https://extensions.gnome.org/extension-data/io.github.mreditor.gnome-shell-extensions.scroll-panel.v10.shell-extension.zip
        echo "Scroll Panel downloaded"
        gnome-extensions install io.github.mreditor.gnome-shell-extensions.scroll-panel.v10.shell-extension.zip
        echo "Scroll Panel has been installed"
        sudo rm -r gnome-shell-extension-scroll-panel
        wget https://extensions.gnome.org/extension-data/widgetsaylur.v24.shell-extension.zip
        echo "Aylur's Widgets downloaded"
        gnome-extensions install widgetsaylur.v24.shell-extension.zip
        echo "Aylur's Widgets has been installed"
        sudo rm widgetsaylur.v24.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/ddtermamezin.github.com.v43.shell-extension.zip
        echo "ddterm downloaded"
        gnome-extensions install ddtermamezin.github.com.v43.shell-extension.zip
        echo "ddterm has been installed"
        sudo rm ddtermamezin.github.com.v43.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/gnome-ui-tuneitstime.tech.v17.shell-extension.zip
        echo "Gnome 4x UI Improvements downloaded"
        gnome-extensions install gnome-ui-tuneitstime.tech.v17.shell-extension.zip
        echo "Gnome 4x UI Improvements has been installed"
        sudo rm gnome-ui-tuneitstime.tech.v17.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/blur-my-shellaunetx.v45.shell-extension.zip
        echo "Blur My Shell downloaded"
        gnome-extensions install blur-my-shellaunetx.v45.shell-extension.zip
        echo "Blur My Shell has been installed"
        sudo rm blur-my-shellaunetx.v45.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/MaximizeToEmptyWorkspace-extensionkaisersite.de.v13.shell-extension.zip
        echo "Maximize To Empty Workspace downloaded"
        gnome-extensions install MaximizeToEmptyWorkspace-extensionkaisersite.de.v13.shell-extension.zip
        echo "Maximize To Empty Workspace has been installed"
        sudo rm MaximizeToEmptyWorkspace-extensionkaisersite.de.v13.shell-extension.zip
        printf '\e[1;31mExtensions Installed!\e[m\n'
        wget https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com.v50.shell-extension.zip
        echo "User Themes downloaded"
        gnome-extensions install user-themegnome-shell-extensions.gcampax.github.com.v50.shell-extension.zip
        echo "User Themes has been installed"
        sudo rm user-themegnome-shell-extensions.gcampax.github.com.v50.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip
        echo "AppIndicator Support downloaded"
        gnome-extensions install appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip
        echo "AppIndicator Support has been installed"
        sudo rm appindicatorsupportrgcjonas.gmail.com.v53.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/just-perfection-desktopjust-perfection.v24.shell-extension.zip
        echo "Just Perfection downloaded"
        gnome-extensions install just-perfection-desktopjust-perfection.v24.shell-extension.zip
        echo "Just Perfection has been installed"
        sudo rm just-perfection-desktopjust-perfection.v24.shell-extension.zip
        wget https://extensions.gnome.org/extension-data/wireless-hidchlumskyvaclav.gmail.com.v11.shell-extension.zip
        echo "Wirelles HID downloaded"
        gnome-extensions install wireless-hidchlumskyvaclav.gmail.com.v11.shell-extension.zip
        echo "Wirelles HID has been installed"
        sudo rm wireless-hidchlumskyvaclav.gmail.com.v11.shell-extension.zip
    else
        echo "Moving On!"
    fi
}

arch_install_wallpaper(){ #Installing Wallpapers
    if yes_reply "Do you want to install Wallpapers?" ; then
    echo "Installing Wallpapers"
        git clone https://github.com/saint-13/Linux_Dynamic_Wallpapers.git
        cd Linux_Dynamic_Wallpapers || exit
        echo "Files downloaded"
        sudo cp -r ./Dynamic_Wallpapers/ /usr/share/backgrounds/
        sudo cp ./xml/* /usr/share/gnome-background-properties/
        echo "Wallpapers has been installed"
        cd ~ || exit
        echo "Deleting files used only for the installation process"
        sudo rm -r Linux_Dynamic_Wallpapers
        printf '\e[1;31mWallpapers Installed!\e[m\n'
    else
        echo "Moving On"
    fi
}

arch_enable_extensions(){ #Enabling Installed Extensions
    if yes_reply "Do you want to enable extensions?" ; then
        echo "Enabling some extensions"
        gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
        gnome-extensions enable widgets@aylur
        gnome-extensions enable io.github.mreditor.gnome-shell-extensions.scroll-panel
        gnome-extensions enable ddterm@amezin.github.com
        gnome-extensions enable blur-my-shell@aunetx
        gnome-extensions enable bluetooth-quick-connect@bjarosze.gmail.com
        gnome-extensions enable MaximizeToEmptyWorkspace-extension@kaisersite.de
        gnome-extensions enable gnome-ui-tune@itstime.tech
        gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
        gnome-extenisons enable gamemode@christian.kellner.me
        gnome-extensions enable just-perfection-desktop@just-perfection
        gnome-extenisons enable wireless-hid@chlumskyvaclav.gmail.com
        printf '\e[1;31mExtensions Enabled!\e[m\n'
    else
        echo "Moving On"
    fi
}

arch_apply_settings(){ #Applying Some Settings
    if yes_reply "Do you want to apply settings?" ; then
        echo "Applying Some Settings"
        fc-cache -r
        gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
        gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3
        gsettings set org.gnome.shell.extensions.user-theme name MFN
        gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
        gsettings set org.gnome.desktop.background picture-uri file:///usr/share/backgrounds/Dynamic_Wallpapers/MaterialMountains/MaterialMountains-1.png
        printf '\e[1;31mSettings Applied!\e[m\n'
    else
        echo "Nothing left to do!"
    fi
}

post_install_nobara(){
    echo "You are using Nobara"
    update_system; bashbar 10
    install_flatpak; bashbar 15
    install_theming; bashbar 20
    install_libre_office; bashbar 30
    install_gaming; bashbar 40
    install_photo_tools; bashbar 50
    install_virtualization; bashbar 60
    install_configs; bashbar 75
    install_extensions; bashbar 85
    install_wallpaper; bashbar 90
    enable_extensions; bashbar 95
    apply_settings; bashbar 100
}

post_install_arch(){
    echo "You are using Arch Linux"
    arch_do_updates; bashbar 10
    arch_install_yay; bashbar 15
    arch_install_flatpak; bashbar 20
    arch_install_theming; bashbar 25
    arch_install_libre_office; bashbar 30
    arch_install_gaming; bashbar 40
    arch_install_photo_tools; bashbar 50
    arch_install_virtualization; bashbar 60
    arch_install_configs; bashbar 75
    arch_install_extensions; bashbar 85
    arch_install_wallpaper; bashbar 90
    arch_enable_extensions; bashbar 95
    arch_apply_settings; bashbar 100
}

main(){
    cd ~/ || exit

    #Checking to see if the system is a Nobara Linux
    if [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Nobara"* ]]; then
        post_install_nobara
    else 
        echo "You are not using Nobara checking others"
    fi

    #Checking to see if the system is a Arch Linux or derivatives
    if [[ $(grep PRETTY /etc/os-release | cut -c 13-) = *"Arch"* || $(grep PRETTY /etc/os-release | cut -c 13-) = *"Endeavour"* || $(grep PRETTY /etc/os-release | cut -c 13-) = *"Garuda"* ]]; then
        post_install_arch
    else 
        echo "You are not using Arch Linux or derivatives"
    fi
  
    printf '\e[1;31mFINISHED!\e[m\n'
}; main "$@"
