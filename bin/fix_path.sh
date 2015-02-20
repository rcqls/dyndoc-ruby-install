#!/bin/bash
DYNDOC_HOME=~/dyndoc

#TODO: fix path for R 

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