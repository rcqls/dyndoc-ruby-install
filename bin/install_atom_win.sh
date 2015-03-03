#!/bin/bash

DYNDOC_HOME=~/dyndoc

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

prevdir=$(pwd)

if [[ $(uname) =~ ^(MSYS) ]]
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
		echo >>  ${HOME}/${rcFile}
		echo "## added automatically when installing dyndoc ruby" >>  ${HOME}/${rcFile}
		echo "export PATH=\"$DYNDOC_HOME/install/Atom:$DYNDOC_HOME/install/Atom/resources/app/apm/bin:\$PATH\"" >> ${HOME}/${rcFile}
		. ${HOME}/${rcFile}
		echo " -> done!"
	else
		echo " -> skipped!"
	fi

	read -p "Do you want to install atom packages now in MINGW console? [Y/N]" -n 1 -r
	echo
	if [[ "$REPLY" =~ ^[Yy]$ ]]
	then
		msys_root=$(ruby -e "print ENV['WD'].split('\\\\')[0...-2].join(File::Separator)")
		$msys_root/mingw32_shell.bat $SCRIPTPATH/install_atom_dyndoc.sh
	fi

fi


cd $prevdir
