#!/bin/bash

DYNDOC_HOME=~/dyndoc

prevdir=$(pwd)

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
