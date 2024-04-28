#!/bin/bash
# by Isaac (hhk02)
progress=0
TSOCLIENT_DIR="https://beta.freeso.org/LauncherResourceCentral/TheSimsOnline"
SIMNATION_URL="http://simnation.ddns.net/patch.zip"



InstallSimNation () {
	cd ..
	clear
	if [ -f "$HOME/SimNation/FreeSO.exe" ]; then
		zenity --info --title="SimNation already installed!" --text="SimNation is already installed! Run now..."
		cd $HOME/SimNation
		mono FreeSO.exe
	else
		while [ ! $progress -eq 100 ]
		do
			echo $progress += 25
			curl -L $SIMNATION_URL --output simnation.zip
			echo $progress += 100
			sleep 1
		done | zenity --progress --title "Downloading SimNation client...." --text "Downloading SimNation client...." --percentage="$progress" --auto-close
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			unzip simnation.zip -d $HOME/SimNation
			echo $progress += 100
			sleep 1
		done | zenity --progress --title "Extracting SimNation client..." --text "Extracting SimNation client...."  --percentage="$progress" --auto-close
		clear
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			cp -v $HOME/SimNation/Monogame/Linux/* $HOME/SimNation
			echo $progress += 100
			sleep 1
		done | zenity --progress --title "Extracting necessary files for Linux...." --text"Extracting"  --percentage="$progress" --auto-close
		echo "SimNation installed!"
		cd $HOME/SimNation
		clear
		zenity --info --title "SimNation installed folder:" --text $(pwd)
		zenity --info --title "How to run SimNation?" --text "Write mono FreeSO.exe or mono FreeSO.exe -3d for run the game! MAKE SURE YOU ARE INSIDE OF SIMNATION FOLDER FOR RUN!"
	mono FreeSO.exe
	fi
}


DownloadTSO () {
	if [ -d "$HOME/SimNation/game/TSOClient" ]; then
		clear
		echo "TSO already installed!"
		InstallSimNation
	else
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			curl -L $TSOCLIENT_DIR --output tso.zip
			echo $progress += 100
			sleep 1
		done | zenity --progress --title "Downloading TSO client!" --auto-close --text "Downloading..."  --percentage="$progress" --auto-close
		clear
		mkdir -v tso
		mkdir -p $HOME/SimNation/game
		clear
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			unzip tso.zip -d tso/
			echo $progress += 100
			sleep 1
		done | zenity --progress --title "Extracting TSO setup files!" --auto-close --text "Extracting"  --percentage="$progress" --auto-close
		cd tso/
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			cabextract Data1.cab -d $HOME/SimNation/game
			sleep 1
			echo $progress += 100
		done | zenity --progress --title "Extracting TSO client" --text "Extracting" --auto-close  --percentage="$progress" --auto-close
		echo "Done!"
		InstallSimNation
	fi
}


InstallDependencies () {
	if [ -f /usr/bin/apt ]; then
		pkexec apt install zenity -y
		echo "Debian/Ubuntu Distro based detected!"
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			pkexec apt update && pkexec apt install wget curl mono-devel libsdl2-dev cabextract unzip libopenal-dev pv -y
			sleep 1
			echo $progress += 100
		done | zenity --progress --text "Installing dependencies..." --auto-close --title "Installing dependencies...."  --percentage="$progress" --auto-close
	fi
	if [ -f /usr/bin/dnf ]; then
		pkexec dnf install zenity -y
		echo "Fedora Distro based detected!"
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			pkexec dnf update && pkexec dnf install wget curl mono-devel sdl2 cabextract unzip openal-soft pv -y 
			sleep 1
			echo $progress += 100
		done | zenity --title "Installing dependencies..." --progress --auto-close --text "Installing....."  --percentage="$progress" --auto-close
		echo "Done!"
	fi
	if [ -f /usr/bin/pacman ]; then
		pkexec pacman -S zenity --no-confirm
		echo "Arch Linux Distro based detected!"
		while [ ! $progress -eq "100" ]
		do
			echo $progress += 25
			pkexec pacman -Sy && pkexec pacman -S wget curl mono sdl2 cabextract unzip openal pv --no-confirm 
			sleep 1
			echo $progress += 100
		done | zenity --title "Installing dependencies..." --progress --auto-close --text "Installing....."  --percentage="$progress" --auto-close
	fi
	DownloadTSO
	clear
}
InstallDependencies
