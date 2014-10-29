#!/bin/bash

echo check git
if [ $(which git) == "" ]; then
	echo "git is not installed!" 
 	exit
else
	echo ok
fi

echo check ruby
if [ $(which ruby) == "" ]; then
	echo "ruby is not installed!" 
 	exit
else
	echo ok
fi

echo check R
if [ $(which R) == "" ]; then
	echo "R is not installed!" 
 	exit
else
	echo ok
fi

echo check gem
if [ $(which gem) == "" ]; then
	echo "gem is not installed!" 
 	exit
else
	echo ok
fi

echo check atom
if [ $(which atom) == "" ]; then
	echo "atom is not installed!" 
 	exit
else
	echo ok
fi

echo check apm
if [ $(which apm) == "" ]; then
	echo "apm is not installed!" 
 	exit
else
	echo ok
fi

mkdir -p ../install
echo install bundler gem
gem install bundler --no-ri --no-rdoc

echo check bundle
if [ $(which bundle) == "" ]; then
	echo "bundle is not installed!"
 	read -p "Add `ruby -e 'print Gem.user_dir'`/bin to PATH in ~/.bash_profile? [Y/N]" -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		`cat bash_profile` >> ${HOME}/.bash_profile
		. ${HOME}/.bash_profile
	fi
fi
echo recheck bundle
if [ $(which bundle) == "" ]; then
	echo "bundle is not installed!" 
 	exit
else
	echo ok
fi
echo install dyndoc dependencies
bundle install
echo install rb4R R package
cd ../install
git clone https://github.com/rcqls/rb4R.git
R CMD INSTALL rb4R
echo install atom packages 
git clone https://github.com/rcqls/dyndoc-syntax.git
git clone https://github.com/rcqls/atom-dyndoc-viewer.git
apm link dyndoc-syntax/atom/language-dyndoc
apm link atom-dyndoc-viewer
