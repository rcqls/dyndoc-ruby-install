#!/bin/bash
DYNDOC_HOME=~/dyndoc


prevdir=$(pwd)

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

cd $prevdir

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

echo "check gem in PATH"
if [ "$(which gem)" = "" ]; then
	echo "gem is not installed!" 
 	exit
else
	echo ok
fi

echo "check R in PATH"
if [ "$(which R)" = "" ]; then
	echo "R is not installed or in the PATH!"
 	exit
else
	echo ok
fi

echo "check pandoc in PATH"
if [ "$(which pandoc)" = "" ]; then
	echo "pandoc is not installed or in the PATH!" 
 	exit
else
	echo ok
fi

echo "check make in PATH"
if [ "$(which make)" = "" ]; then
	if [[ $(uname) =~ ^(MSYS) ]]
	then
		echo "install make" 
 		pacman -S --noconfirm make
 		echo ok
 	else
 		echo "make is not installed!" 
 		exit
 	fi
else
	echo ok
fi

echo "check gcc in PATH"
if [ "$(which gcc)" = "" ]; then
	if [[ $(uname) =~ ^(MSYS) ]]
	then
		echo "install gcc" 
 		pacman -S --noconfirm gcc
 		echo ok
 	else
 		echo "gcc is not installed!" 
 		exit
 	fi
else
	echo ok
fi

echo "copy dyndoc home directory"
if [ -d $DYNDOC_HOME ] 
then
	read -p "$DYNDOC_HOME already exists, do you want to copy anyway [Y/N]" -n 1 -r
	echo 
	if [[ "$REPLY" =~ ^[Yy]$ ]]; then ans="ok"; else ans=""; fi
else
	ans="ok"
fi
if [ "$ans" = "ok" ]
then 
	mkdir -p $DYNDOC_HOME
	cp -r $SCRIPTPATH/../dyndoc_basic_root_structure/* $DYNDOC_HOME
	ln -s $DYNDOC_HOME/bin/dyndoc-compile.rb $DYNDOC_HOME/bin/dyn
	ln -s $DYNDOC_HOME/bin/dyndoc-package.rb $DYNDOC_HOME/bin/dpm
fi

mkdir -p $DYNDOC_HOME/install
if [ "$(gem which bundler)" = "" ]; then
	echo install bundler gem
	gem sources -r https://rubygems.org
	gem sources -a http://rubygems.org
	gem install bundler --no-ri --no-rdoc --user-install
fi

echo "check bundle in PATH"
if [ "$(which bundle)" = "" ]; then
	echo "bundle is not in PATH!"
 	read -p "Add `ruby -e 'print Gem.user_dir'`/bin to PATH? [1=~/.bash_profile, 2=~/.profile, 3=~/.bashrc, *=No]" -n 1 -r
	echo    # (optional) move to a new line
	case "$REPLY" in
		1)
	    	rcFile=".bash_profile"
	    ;;
		2)
			rcFile=".profile"
			echo "WARNING: if you have a linux system, maybe you'll need to reopen your windows manager!"
	    ;;
	 	3)
			rcFile=".bashrc"
	    ;;
		*)
	    ""
    	;;
	esac
	if [[ "${rcFile}" != "" ]]
	then
		echo "## added automatically when installing dyndoc ruby" >>  ${HOME}/${rcFile}
		echo `cat $SCRIPTPATH/bash_profile` >> ${HOME}/${rcFile}
		. ${HOME}/${rcFile}
	fi
	echo "recheck bundle in PATH"
	if [ "$(which bundle)" = "" ]; then
		echo "bundle is not installed!" 
	 	exit
	else
		echo ok
	fi
else
	echo ok
fi

echo "install dyndoc dependencies"
gem install configliere --no-ri --no-rdoc --user-install
gem install ultraviolet --no-ri --no-rdoc --user-install


echo "install ruby stuff: R4rb, dyndoc-ruby-core and dyndoc-ruby-doc gems"
mkdir -p $DYNDOC_HOME/install/ruby
cd $DYNDOC_HOME/install/ruby
git clone git://github.com/rcqls/R4rb.git
if [[ $(uname) =~ ^(MSYS) ]]
then
	echo "install R4rb dependencies" 
	pacman -S --noconfirm libcrypt-devel gmp-devel
	echo ok
fi
cd R4rb;rake install
cd $DYNDOC_HOME/install/ruby
git clone git://github.com/rcqls/dyndoc-ruby-core.git
cd dyndoc-ruby-core;rake install
cd $DYNDOC_HOME/install/ruby
git clone git://github.com/rcqls/dyndoc-ruby-doc.git
cd dyndoc-ruby-doc;rake install

echo "install R stuff: rb4R R package"
mkdir -p $DYNDOC_HOME/install/R
cd $DYNDOC_HOME/install/R
git clone git://github.com/rcqls/rb4R.git
PREFIX_R=""
## specific treatment for MSYS system
if [[ $(uname) =~ ^(MSYS) ]]; then
	mkdir -p library
	echo  "export R_LIBS_USER=$DYNDOC_HOME/install/R/library" >> ${HOME}/.bash_profile
	echo "Warning: export R_LIBS_USER=$DYNDOC_HOME/install/R/library added in .bash_profile"
fi
if [ "$R_LIBS_USER" != ""  ]; then
	PREFIX_R="-l $R_LIBS_USER"
fi
R CMD INSTALL $PREFIX_R rb4R

cd ${prevdir}

