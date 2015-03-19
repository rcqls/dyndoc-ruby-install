#!/bin/bash
cd ~/dyndoc/bin
echo "Download dyndoc_update.sh script inside ~/dyndoc/bin"
mkdir .tmp
cd .tmp
wget https://raw.githubusercontent.com/rcqls/dyndoc-ruby-install/master/dyndoc_basic_root_structure/bin/dyndoc_update.sh
cd ..
cp .tmp/dyndoc_update.sh .
rm -fr .tmp
. ~/.bash_profile