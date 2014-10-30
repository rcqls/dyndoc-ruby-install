#!/bin/bash

DYNDOC_HOME=~/dyndoc

prevdir=$(pwd)
if [[ $(uname) =~ ^(MSYS|MINGW) ]]
then
	read -p "Do you want to install atom editor in $DYNDOC_HOME/install [Y/N]" -n 1 -r
	echo
	echo "atom installation"
	if [[ "$REPLY" =~ ^[Yy]$ ]]
	then
		mkdir -p $DYNDOC_HOME/install
		cd $DYNDOC_HOME/install
		echo "check wget and unzip in PATH"
		if [ "$(which wget)" = "" ]; then
			echo "install wget!" 
		 	pacman -S --noconfirm wget
		fi
		if [ "$(which unzip)" = "" ]; then
			echo "install unzip!" 
		 	pacman -S --noconfirm unzip
		fi
		lastversion=$(ruby -ropen-uri -e 'print /v\d*\.\d*\.\d*/.match(open("https://atom.io/releases").read)[0]')
		wget https://github.com/atom/atom/releases/download/${lastversion}/atom-windows.zip
		unzip atom-windows.zip
		echo " -> done!"
	else
		echo " -> skipped!"
	fi

	read -p "Do you want to add atom and apm to PATH [Y/N]" -n 1 -r
	echo
	echo "atom and apm added to PATH"
	if [[ "$REPLY" =~ ^[Yy]$ ]]
	then
		rcFile=".bash_profile"
		echo "## added automatically when installing dyndoc ruby" >>  ${HOME}/${rcFile}
		echo "export PATH=$DYNDOC_HOME/install/Atom:$DYNDOC_HOME/install/Atom/resources/app/apm/node_modules/atom-package-manager/bin:$PATH" >> ${HOME}/${rcFile}
		. ${HOME}/${rcFile}
		echo " -> done!"
	else
		echo " -> skipped!"
	fi

fi


echo "check atom in PATH"
if [ "$(which atom)" = "" ]; then
	echo "atom is needed to complete the installation!" 
 	exit
else
	echo ok
fi

echo "check apm in PATH"
if [ "$(which apm)" = "" ]; then
	echo "apm is needed to complete the installation!" 
 	exit
else
	echo ok
fi



read -p "Do you want to install (dyndoc) atom packages [Y/N]" -n 1 -r
echo
echo "install atom packages "
if [[ "$REPLY" =~ ^[Yy]$ ]]
then
	if [[ $MSYSTEM =~ ^MSYS ]]; then
		echo "Open this script inside a MINGW console!"
		exit
	fi
	mkdir -p $DYNDOC_HOME/install/share
	cd $DYNDOC_HOME/install/share
	git clone https://github.com/rcqls/dyndoc-syntax.git
	git clone https://github.com/rcqls/atom-dyndoc-viewer.git
	apm link dyndoc-syntax/atom/language-dyndoc
	apm link atom-dyndoc-viewer
	cd atom-dyndoc-viewer
	apm install;apm rebuild
	apm install language-r
	echo " -> done!"
else
	echo " -> skipped!"
fi

cd $prevdir
