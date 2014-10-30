#!/bin/bash 
DYNDOC_HOME=~/dyndoc

echo "check atom in PATH"
if [ "$(which atom)" = "" ]; then
	echo "atom is not installed!"
	if [[ $(uname) =~ ^(MSYS|MINGW) ]]
	then
		read -p "Do you want to install it in $DYNDOC_HOME/install [Y/N]" -n 1 -r
		echo 
		if [[ "$REPLY" =~ ^[Yy]$ ]]
		then
			prevdir=$(pwd)
			mkdir -p $DYNDOC_HOME/install/atom
			cd 
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
			cd ${prevdir}
		fi

	fi
 	exit
else
	echo ok
fi
