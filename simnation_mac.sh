#!/bin/bash
# by Isaac (hhk02)

export TSOCLIENT_DIR="https://beta.freeso.org/LauncherResourceCentral/TheSimsOnline"
export SIMNATION_URL="http://simnation.ddns.net/patch.zip"
export MONO_URL="https://beta.freeso.org/LauncherResourceCentral/Mono"
export SDL_URL="https://beta.freeso.org/LauncherResourceCentral/SDL"
export MACEXTRAS="https://beta.freeso.org/LauncherResourceCentral/MacExtras"
InstallSimNation () {
    echo "Downloading"
    mkdir -p "$HOME/Documents/SimNation/"
    curl -L $SIMNATION_URL --output simnation.zip
    unzip simnation.zip -d "$HOME/Documents/SimNation"
    cd "$HOME/Documents/SimNation"
    curl -L $MACEXTRAS --output macextras.zip
    unzip macextras.zip
    mono FreeSO.exe
}

DownloadTSO () {
    clear
	if [ -d "$HOME/Documents/The Sims Online/TSOClient" ]; then
		clear
		echo "TSO already installed!"
		InstallSimNation
	else
        	curl -L $TSOCLIENT_DIR --output tso.zip
		clear
		mkdir -v tso
		mkdir -p "$HOME/Documents/The Sims Online"
		clear
		unzip tso.zip -d tso/
		cd tso
  		# Install Brew
        	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	 	brew install cabextract
		cabextract Data1.cab -d "$HOME/Documents/The Sims Online"
		echo "Done!"
		InstallSimNation
	fi
}

DownloadSDL() {
    if [ -f /usr/bin/curl ]; then
        curl -L "$SDL_URL" --output sdl.dmg
        sudo hdiutil attach sdl.dmg
	if [ -f /Library/Frameworks/SDL2.framework ]; then
        	sudo rm -rf /Library/Frameworks/SDL2.framework
        fi
	sudo cp -R /Volumes/SDL2/SDL2.framework /Library/Frameworks
        sudo hdiutil unmount /Volumes/SDL2
        DownloadTSO
    fi
}

DownloadMono() {
    if [ -f /usr/bin/curl ]; then
        echo "Curl detected!"
        curl -L "$MONO_URL" --output mono.pkg
        echo "You need install this for run SimNation!"
        sudo installer -pkg mono.pkg -target /
        DownloadSDL
    fi
}

DownloadMono
