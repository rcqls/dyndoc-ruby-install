#!/bin/bash
#!/bin/bash

echo "check git in PATH"
if [ "$(which git)" = "" ]; then
	echo "git is not installed!" 
 	exit
else
	echo ok
fi

echo "check ruby in PATH"
if [ "$(which ruby)" = "" ]; then
	echo "ruby is not installed!" 
 	exit
else
	echo ok
fi

echo "check R in PATH"
if [ "$(which R)" = "" ]; then
	echo "R is not installed!" 
 	exit
else
	echo ok
fi

echo "check gem in PATH"
if [ "$(which gem)" = "" ]; then
	echo "gem is not installed!" 
 	exit
else
	echo ok
fi

echo "check atom in PATH"
if [ "$(which atom)" = "" ]; then
	echo "atom is not installed!" 
 	exit
else
	echo ok
fi

echo "check apm in PATH"
if [ "$(which apm)" = "" ]; then
	echo "apm is not installed!" 
 	exit
else
	echo ok
fi

mkdir -p ../install
if [ "$(gem which bundler)" = "" ]; then
	echo install bundler gem
	gem install bundler --no-ri --no-rdoc
fi

echo check bundle in PATH
if [ "$(which bundle)" = "" ]; then
	echo "bundle is not installed!"
 	read -p "Add `ruby -e 'print Gem.user_dir'`/bin to PATH in ~/.bash_profile? [Y/N]" -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		echo "## added automatically when installing dyndoc ruby" >>  ${HOME}/.bash_profile
		echo `cat bash_profile` >> ${HOME}/.bash_profile
		. ${HOME}/.bash_profile
	fi
fi
echo recheck bundle
if [ "$(which bundle)" = "" ]; then
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

