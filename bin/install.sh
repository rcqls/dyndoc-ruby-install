#!/bin/bash

echo check git
if [ $(which git) == "" ]; then
	echo "git is not installed!" 
 	exit
fi

echo check gem
if [ $(which gem) == "" ]; then
	echo "gem is not installed!" 
 	exit
fi

echo check atom
if [ $(which atom) == "" ]; then
	echo "atom is not installed!" 
 	exit
fi

echo check apm
if [ $(which apm) == "" ]; then
	echo "apm is not installed!" 
 	exit
fi

mkdir -p ../install
echo install bundler gem
gem install bundler --no-ri --no-rdoc
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
