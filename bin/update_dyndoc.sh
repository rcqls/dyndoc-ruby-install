#!/bin/bash
DYNDOC_HOME=~/dyndoc


prevdir=$(pwd)

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

cd $prevdir

if [ -d $DYNDOC_HOME/install/ruby ]; then
	echo "ruby update: R4rb, dyndoc-ruby-core and dyndoc-ruby-doc gems"
	cd $DYNDOC_HOME/install/ruby
	cd R4rb;git pull;rake install
	cd $DYNDOC_HOME/install/ruby
	cd dyndoc-ruby-core;git pull;rake install
	cd $DYNDOC_HOME/install/ruby
	cd dyndoc-ruby-doc;git pull;rake install
else
	echo "ruby update available only when $DYNDOC_HOME/install/ruby exists"
fi

if [ -d $DYNDOC_HOME/install/R ]; then
	echo "R update: rb4R R package"
	cd $DYNDOC_HOME/install/R
	cd rb4R;git pull;cd ..
	PREFIX_R=""
	if [ "$R_LIBS_USER" != ""  ]; then
		PREFIX_R="-l $R_LIBS_USER"
	fi
	R CMD INSTALL $PREFIX_R rb4R
else
	echo "R update available only when $DYNDOC_HOME/install/R exists"
fi	

cd ${prevdir}

