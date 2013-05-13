#!/bin/bash
echo "Installer Script for Xubuntu 12.10"
if [ "$(whoami)" == 'root' ]
  then echo 'do not run this as root for user detection'
  exit 1;
fi

DEV=false
OPTIMUS=false
XFCE=false
#OS=$(lsb_release -si)
#ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
VER=$(lsb_release -sr)

check_DE() {
    # $1 = desktop environment boolean
    local PACKAGE_NAME=$2
    if dpkg -s "$PACKAGE_NAME" 2>/dev/null 1>/dev/null; then
        eval ${1}=true
    else
        eval ${1}=false
    fi
}

echo "Checking script conditionals"
if [ "$(whoami)" == 'joe' ]; then
    # then define "DEV" for development install
    DEV=true
fi
if [ "$(hostname)" == 'joe-laptop' ]; then
    # then define "laptop" for nvidia / optimus / bumblebee
    OPTIMUS=true
fi
check_DE XFCE "xfwm4"

echo "Add PPA's and sources"
sudo add-apt-repository -y ppa:kilian/f.lux
sudo apt-add-repository -y ppa:ehoover/compholio
if $OPTIMUS; then
    sudo add-apt-repository -y ppa:ubuntu-x-swat/x-updates
    sudo add-apt-repository -y ppa:bumblebee/stable
fi
if $DEV; then
    sudo add-apt-repository -y ppa:webupd8team/java
fi
if $XFCE; then
    # PPA for Thunar and multimonitor support
    sudo add-apt-repository -y ppa:xubuntu-dev/xfce-4.12
fi
#if [ $VER == "12.10" ]; then
#    echo "Install ownCloud repositories"
#    sudo echo 'deb http://download.opensuse.org/repositories/isv:ownCloud:devel/xUbuntu_12.10/ /' >> /etc/apt/sources.list.d/owncloud-client.list
#    wget http://download.opensuse.org/repositories/isv:ownCloud:devel/xUbuntu_12.10/Release.key
#    sudo apt-key add - < Release.key
#    sudo apt-get update
#    sudo apt-get install owncloud-client
#fi

echo "Update Sources"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

echo "Install PPA Applications"
sudo apt-get install -y fluxgui
# requires manual input
sudo apt-get install -y netflix-desktop
if $OPTIMUS; then
    sudo apt-get install -y bumblebee bumblebee-nvidia linux-headers-generic
    sudo apt-get install -y primus primus-libs-ia32:i386
fi
if $DEV; then
    # requires manual input
    sudo apt-get install -y oracle-java6-installer
fi
if $XFCE; then
    # Quit and restart thunar to upgrade 1.4 to 1.6+
    thunar -q
    # make sure xfce4-display-settings -m is a shortcut (super-P, Fn-F8)
fi

echo "Install Applications"
sudo apt-get install -y vlc gedit gthumb clementine nautilus-dropbox pidgin p7zip-full gparted gnome-disk-utility libreoffice-writer libreoffice-calc libreoffice-impress unetbootin chromium-browser sshfs grsync
#sudo apt-get install -y okular digikam calligra
echo "Install Required Library for Office 2007"
sudo apt-get install -y libjpeg62:i386
if $DEV; then
    echo "Install Android Development Tools and Dependencies"
    sudo apt-get install -y android-tools-adb android-tools-fastboot git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.8-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev lib32z1-dev pngcrush schedtool g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline-gplv2-dev gcc-multilib g++-multilib schedtool libc6-dev-i386 ccache
    # Java installed from Oracle PPA
    #sudo apt-get install -y openjdk-6-jre openjdk-6-jdk
    echo "Installing Development Tools"
    sudo apt-get install -y gedit-plugins vim qtcreator git gitk gtkhash libgsl0-dev libgsl0ldbl
fi
if $XFCE; then
    echo "Install Xubuntu Specific"
    sudo apt-get install -y xubuntu-restricted-extras
fi

echo "Install .deb's from Internet"
#get / curl / whatever the hell
# install googletalk plugin
# install playonlinux
# joe
# install steam
#http://media.steampowered.com/client/installer/steam.deb

echo "Remove Ubuntu Specific"
rm –rf ~/.local/share/ubuntuone
rm –rf ~/.cache/ubuntuone
rm –rf ~/.config/ubuntuone
rm –rf ~/Ubuntu\ One
sudo apt-get purge -y ubuntuone-client* python-ubuntuone-storage*
echo "Remove Xubuntu Specific"
sudo apt-get remove -y leafpad parole abiword gmusicbrowser
sudo apt-get remove -y empathy unity-lens-shopping
echo "Automatically Remove Packages"
sudo apt-get autoremove

if [$DEV] && [$USER == "joe"]; then
    echo "Setup git"
    git config --global user.name "Joe Black"
    git config --global user.email jblack248@gmail.com
    git config --global core.autocrlf input
    # turns on password caching
    git config --global credential.helper cache
    # sets cache to timeout after one hour
    git config --global credential.helper 'cache --timeout=3600'
fi
if $DEV; then
    echo "Setup udev Rules for adb"
    # requires manual input
    echo "Manual input required - paste below into file."
    echo "
    #Acer
    SUBSYSTEM=="usb", SYSFS{idVendor}=="0502", MODE="0666"
    #Dell
    SUBSYSTEM=="usb", SYSFS{idVendor}=="413c", MODE="0666"
    #Foxconn
    SUBSYSTEM=="usb", SYSFS{idVendor}=="0489", MODE="0666"
    #Garmin-Asus
    SUBSYSTEM=="usb", SYSFS{idVendor}=="091E", MODE="0666"
    #Google
    SUBSYSTEM=="usb", SYSFS{idVendor}=="18d1", MODE="0666"
    #HTC
    SUBSYSTEM=="usb", SYSFS{idVendor}=="0bb4", MODE="0666"
    #Huawei
    SUBSYSTEM=="usb", SYSFS{idVendor}=="12d1", MODE="0666"
    #Kyocera
    SUBSYSTEM=="usb", SYSFS{idVendor}=="0482", MODE="0666"
    #LG
    SUBSYSTEM=="usb", SYSFS{idVendor}=="1004", MODE="0666"
    #Motorola
    SUBSYSTEM=="usb", SYSFS{idVendor}=="22b8", MODE="0666"
    #Nvidia
    SUBSYSTEM=="usb", SYSFS{idVendor}=="0955", MODE="0666"
    #Pantech
    SUBSYSTEM=="usb", SYSFS{idVendor}=="10A9", MODE="0666"
    #Samsung
    SUBSYSTEM=="usb", SYSFS{idVendor}=="04e8", MODE="0666"
    #Sharp
    SUBSYSTEM=="usb", SYSFS{idVendor}=="04dd", MODE="0666"
    #Sony Ericsson
    SUBSYSTEM=="usb", SYSFS{idVendor}=="0fce", MODE="0666"
    #ZTE
    SUBSYSTEM=="usb", SYSFS{idVendor}=="19D2", MODE="0666"
    "
    gksudo gedit /etc/udev/rules.d/99-android.rules
    sudo chmod a+r /etc/udev/rules.d/99-android.rules
    echo "Unplug all Android Devices"
    sudo service udev restart
# run sudo adb kill-server and sudo adb start-server on startup?
    adb kill-server
    adb start-server
    
    echo "Add paths to .bashrc"
    # requires manual input
    echo "Manual input required - paste below into file."
    echo "export USE_CCACHE=1"
    echo "ccache -M 10G > /dev/null 2>&1"
    echo "export PATH=${PATH}:~/Documents/Development/bin:~/Documents/Development/adt-bundle-linux-x86_64/sdk/tools:~/Documents/Development/adt-bundle-linux-x86_64/sdk/platform-tools:~/Documents/Dropbox/Scripts"
    gedit ~/.bashrc
fi

echo "SSD's ONLY - Add relatime and discard manually"
# requires manual input
echo "Manual input required - paste below into file."
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0"
sudo gedit /etc/fstab

echo "Required actions after script:"
echo "Add fluxgui to startup"
echo "Configure Dropbox"
echo "Install CrossOver and Office 2007 SP3"
echo "Run Netflix once for initial setup"

echo "map Pause/Break or other to:"
echo "amixer set Capture toggle"


echo "Set Driver=nvidia in /etc/bumblebee/bumblebee.conf"

echo "Optimus support for Steam Linux"
echo "Add OPTIMUS_PREFIX=”primusrun” to /etc/environment"
echo "Click the SET LAUNCH OPTIONS... button and specify $OPTIMUS_PREFIX %command% for the command line."

# qt creator
# File->Session Manager->Restore Last Session on Startup
# 80 column line

#solarized color scheme for terminal, qt creator, gedit
#git color scheme
#copy dark/terminalrc into ~/.config/Terminal/

#install dockbarx
#swap file
#printer

#firefox
#install xmarks, lastpass, adblockplus
#setup to delete all history on close
#hide menu bar, use small icons, move icons to the left side
#preferences->privacy
#use custom settings, keep until firefox closes, clear all at close
#move adblock plus icon above lastpass icon
#enable bookmarks toolbar

#Xfconf -query
#http://docs.xfce.org/xfce/xfce4-power-manager/preferences

#Linux automatic sound configuration
#for HDMI / laptop audio switching

